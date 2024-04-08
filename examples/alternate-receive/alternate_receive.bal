import ballerina/io;
import ballerina/lang.runtime;

public function main() {
    worker w1 {
        2 -> w3;
    }

    worker w2 {
        runtime:sleep(2);
        3 -> w3;
    }

    worker w3 returns int {
        // The value of the variable `result` is set as soon as the values from either
        // worker `w1` or `w2` is received.
        int result = <- w1 | w2;
        return result;
    }

    worker w4 returns error? {
        int value = 10;
        if value == 10 {
            return error("Error in worker 1");
        }
        value -> w6;
    }

    worker w5 {
        runtime:sleep(2);
        3 -> w6;
    }

    worker w6 returns int|error? {
        // Alternate receive action waits until a message that is not an error is received 
        // when error is not an expected static type. Since `w4` returns an error it 
        // waits further and sets the value that is received from `w5`.
        int a = check <- w4 | w5;
        return a;
    }

    int valueW3 = wait w3;
    io:println(valueW3);

    int|error? valueW6 = wait w6;
    io:println(valueW6);
}
