/*
 * Copyright (c) 2017, WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
 *
 * WSO2 Inc. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.stdlib.io.channels.base;

import io.ballerina.stdlib.io.csv.Format;
import io.ballerina.stdlib.io.utils.BallerinaIOException;

import java.io.IOException;
import java.util.regex.Pattern;

/**
 * <p>
 * Allows performing record I/O operations.
 * </p>
 * <p>
 * A readRecord will have a readRecord separator and a field separator.
 * </p>
 * <p>
 * <b>Note : </b> this channel does not support concurrent operations, since underlying CharacterChannel is not
 * synchronous.
 * </p>
 */
public class DelimitedRecordChannel implements IOChannel {

    /**
     * Distinguishes the Record.
     */
    private String recordSeparator;

    /**
     * Record contains multiple fields, each field is separated through the field separator.
     */
    private String fieldSeparator;

    /**
     * Once the record is being identified the remaining string would hold the remaining elements.
     */
    private StringBuilder persistentCharSequence;

    /**
     * A rough character count which will contain a record. This will be resized dynamically if the length of the
     * record is long.
     */
    private int recordCharacterCount = 100;

    /**
     * Read/Writes characters.
     */
    private CharacterChannel channel;

    /**
     * <p>
     * Specified whether there're any remaining records left to be read from the channel.
     * </p>
     * <p>
     * This will be false if there're no characters remaining in the persistentCharSequence and the the channel has
     * reached EoF
     * </p>
     */
    private boolean remaining = true;

    /**
     * Keeps track of the number of records which is being read through the channel.
     */
    private int numberOfRecordsReadThroughChannel = 0;

    /**
     * Keeps track of the number of records written to channel.
     */
    private int numberOfRecordsWrittenToChannel = 0;

    /**
     * Specifies the format for the record. This will be optional
     */
    private Format format;

    private static final String DOUBLE_QUOTE_REGEX = "\"([^\"]*)\"";

    public DelimitedRecordChannel(CharacterChannel channel, Format format) {
        this.channel = channel;
        this.format = format;
        this.persistentCharSequence = new StringBuilder();
    }

    public DelimitedRecordChannel(CharacterChannel channel, String recordSeparator, String fieldSeparator) {
        this.recordSeparator = recordSeparator;
        this.fieldSeparator = fieldSeparator;
        this.channel = channel;
        this.persistentCharSequence = new StringBuilder();
    }

    @Override
    public boolean hasReachedEnd() {
        return !remaining && channel.hasReachedEnd();
    }

    public Channel getChannel() {
        return channel.getChannel();
    }

    /**
     * Retrieves the record separator for reading records.
     *
     * @return the record separator.
     */
    private String getRecordSeparatorForReading() {
        if (null == format) {
            return recordSeparator;
        }
        return format.getReadRecSeparator();
    }

    /**
     * Retrieves field separator for reading.
     *
     * @return the field separator.
     */
    private String getFieldSeparatorForReading() {
        if (null == format) {
            return fieldSeparator;
        }
        return format.getReadFieldSeparator();
    }

    /**
     * Retrieves record separator for writing.
     *
     * @return the record separator.
     */
    private String getRecordSeparatorForWriting() {
        if (null == format) {
            return recordSeparator;
        }
        return format.getWriteRecSeparator();
    }

    /**
     * Retrieves field separator for writing.
     *
     * @return the field separator.
     */
    private String getFieldSeparatorForWriting() {
        if (null == format) {
            return fieldSeparator;
        }
        return format.getWriteFieldSeparator();
    }

    /**
     * <p>
     * Gets record from specified sequence of characters.
     * </p>
     *
     * @return the requested record.
     * @throws BallerinaIOException during I/O error.
     */
    private String readRecord() throws BallerinaIOException {
        String record = null;
        final int minimumRecordCount = 1;
        final int numberOfSplits = 2;
        do {
            //We need to split the string into 2
            String[] delimitedRecord = persistentCharSequence.toString().
                    split(getRecordSeparatorForReading(), numberOfSplits);
            if (delimitedRecord.length > minimumRecordCount) {
                record = processIdentifiedRecord(delimitedRecord);
                int recordCharacterLength = record.length();
                if (recordCharacterLength > recordCharacterCount) {
                    recordCharacterCount = record.length();
                }
            } else {
                readRecordFromChannel();
                if (channel.hasReachedEnd()) {
                    delimitedRecord = persistentCharSequence.toString().
                            split(getRecordSeparatorForReading(), numberOfSplits);
                    record = (delimitedRecord.length == numberOfSplits) ?
                            processIdentifiedRecord(delimitedRecord) :
                            readFinalRecord();
                }
            }
        } while (record == null && !channel.hasReachedEnd());

        if (null == record) {
            record = readFinalRecord();
        }
        return record;
    }

    /**
     * <p>
     * Reads the remaining set of characters as the final record.
     * </p>
     * <p>
     * This operation is called when there're no more content to be retrieved from the the channel.
     * </p>
     */
    private String readFinalRecord() {
        final int minimumRemainingLength = 0;
        String record = "";
        //This means this will be the last record which could be get
        this.remaining = false;
        //If there're any remaining characters left we provide it as the last record
        if (persistentCharSequence.length() > minimumRemainingLength) {
            record = persistentCharSequence.toString();
            //Once the final record is processed there will be no chars left
            persistentCharSequence.setLength(minimumRemainingLength);
        }
        return record;
    }

    /**
     * <p>
     * Reads a record from the channel.
     * </p>
     *
     * @return the record content.
     */
    private String readRecordFromChannel() throws BallerinaIOException {
        String readCharacters;
        readCharacters = channel.read(recordCharacterCount);
        persistentCharSequence.append(readCharacters);
        return readCharacters;
    }

    /**
     * <p>
     * Identifies the record from the provided collection.
     * </p>
     * <p>
     * <b>Note :</b> This operation would append the remaining content to the string.
     * </p>
     *
     * @param delimitedRecords collection of records which required to be split.
     * @return the record content value.
     */
    private String processIdentifiedRecord(String[] delimitedRecords) {
        String record;
        final int minimumRemainingLength = 0;
        final int delimitedRecordIndex = 0;
        final int delimitedRemainingIndex = 1;
        String recordContent = delimitedRecords[delimitedRemainingIndex];
        record = delimitedRecords[delimitedRecordIndex];
        persistentCharSequence.setLength(minimumRemainingLength);
        persistentCharSequence.append(recordContent);
        return record;
    }

    /**
     * <p>
     * Split based on given regEx.
     * </p>
     * <p>
     * This operation will produce null for blanks.
     * </p>
     *
     * @param record record which should be separated.
     * @param regex  condition which should be used to split.
     * @return the list of fields
     */
    private String[] splitIgnoreBlanks(String record, String regex) {
        Pattern reg = Pattern.compile(regex);
        String[] split = reg.split(record);
        for (int i = 0; i < split.length; i++) {
            String field = split[i];
            if (field.isEmpty()) {
                split[i] = "";
                continue;
            }
            if (field.matches(DOUBLE_QUOTE_REGEX)) {
                split[i] = field.substring(field.indexOf('\"') + 1, field.lastIndexOf('\"'));
            }
        }
        return split;
    }

    /**
     * Get the fields identified through the record.
     *
     * @param record the record which contains all the fields.
     * @return fields which are separated as records.
     */
    public String[] getFields(String record) {
        String fieldSeparatorForReading = getFieldSeparatorForReading();
        if (null != format && format.shouldIgnoreBlanks()) {
            return splitIgnoreBlanks(record, fieldSeparatorForReading);
        } else {
            return record.split(fieldSeparatorForReading);
        }
    }

    /**
     * <p>
     * Read the next readRecord.
     * </p>
     * <p>
     * An empty list will be returned if all the records have being processed, all records will be marked as
     * processed if all the content have being retrieved from the provided channel.
     * </p>
     *
     * @return the list of fields.
     * @throws BallerinaIOException during I/O errors
     */
    public String[] read() throws BallerinaIOException {
        final int emptyArrayIndex = 0;
        String[] fields = new String[emptyArrayIndex];
        if (remaining) {
            String record = readRecord();
            if (!record.isEmpty() || remaining) {
                fields = getFields(record);
                numberOfRecordsReadThroughChannel++;
            }
        } 
        return fields;
    }

    /**
     * Enclose a given field with quotes.
     *
     * @param field field which should be enclosed.
     * @return Enclosed field.
     */
    private String encloseField(String field) {
        return "\"" + field + "\"";
    }

    /**
     * Will place the relevant fields together to/form a record.
     *
     * @param fields the list of fields in the record.
     * @return the record constructed through the fields.
     */
    private String composeRecord(String[] fields) {
        StringBuilder recordConsolidator = new StringBuilder();
        String finalizedRecord;
        long numberOfFields = fields.length;
        final int fieldStartIndex = 0;
        final long secondLastFieldIndex = numberOfFields - 1;
        for (int fieldCount = fieldStartIndex; fieldCount < numberOfFields; fieldCount++) {
            String currentFieldString = fields[fieldCount];
            if (currentFieldString.contains(getFieldSeparatorForWriting())) {
                currentFieldString = encloseField(currentFieldString);
            }
            recordConsolidator.append(currentFieldString);
            if (fieldCount < secondLastFieldIndex) {
                //The idea here is to omit appending the field separator after the final field
                recordConsolidator.append(getFieldSeparatorForWriting());
            }
        }
        finalizedRecord = recordConsolidator.toString();
        return finalizedRecord;
    }

    /**
     * Writes a given record to a file.
     *
     * @param fields the list of fields composing the record.
     * @throws IOException during I/O error.
     */
    public void write(String[] fields) throws IOException {
        final int writeOffset = 0;
        String record = composeRecord(fields);
        record = record + getRecordSeparatorForWriting();
        channel.write(record, writeOffset);
        numberOfRecordsWrittenToChannel++;
    }

    /**
     * Provides the id of the channel.
     *
     * @return the id of the channel.
     */
    @Override
    public int id() {
        return channel.id();
    }

    /**
     * Closes the record channel.
     *
     * @throws IOException error occur while closing the connection.
     */
    @Override
    public void close() throws IOException {
        channel.close();
    }

    @Override
    public boolean remaining() {
        return persistentCharSequence.length() > 0;
    }

    /**
     * Check whether there are more records or not.
     *
     * @return true if more records in the channel else false.
     * @throws BallerinaIOException if encoding error or channel reading error happens
     */
    public boolean hasNext() throws BallerinaIOException {
        if (remaining && persistentCharSequence.length() == 0) {
            //If this is the case we need to further verify whether there will be more bytes left to be read
            //Remaining can become false in the next iteration
            String readChars = readRecordFromChannel();
            if (readChars.isEmpty()) {
                remaining = false;
            }
        }
        return remaining;
    }
}
