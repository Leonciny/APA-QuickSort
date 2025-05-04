import java.util.ArrayList;

public class Main {
    public static void main(String[] args) {
        var pool = new ArrayList<Ciao.Thread>();

        var t = new Ciao.Thread(10, 20);

        pool.add(t);
    }
}
