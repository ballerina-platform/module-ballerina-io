module io.ballerina.stdlib.io {
    requires org.slf4j;
    requires io.ballerina.jvm;
    exports org.ballerinalang.stdlib.io.channels;
    exports org.ballerinalang.stdlib.io.channels.base;
    exports org.ballerinalang.stdlib.io.channels.base.data;
    exports org.ballerinalang.stdlib.io.csv;
    exports org.ballerinalang.stdlib.io.nativeimpl;
    exports org.ballerinalang.stdlib.io.readers;
    exports org.ballerinalang.stdlib.io.utils;
}