package io.github.up9cloud.td;
public final class JsonClient {
    static {
        try {
            System.loadLibrary("tdjson");
        } catch (UnsatisfiedLinkError e) {
            e.printStackTrace();
        }
    }
    public static native int td_create_client_id();
    public static native void td_send(int client_id, String request);
    public static native String td_receive(double timeout);
    public static native String td_execute(String request);
    public interface LogMessageCallback {
        void call(int verbosity_level, String message);
    }
    public static native void td_set_log_message_callback(int max_verbosity_level, LogMessageCallback callback);

    public static native long td_json_client_create();
    public static native void td_json_client_send(long client, String request);
    public static native String td_json_client_receive(long client, double timeout);
    public static native String td_json_client_execute(long client, String request);
    public static native void td_json_client_destroy(long client);
}
