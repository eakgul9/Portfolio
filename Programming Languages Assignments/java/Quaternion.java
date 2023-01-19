import java.util.List;

public record Quaternion (double a, double b, double c, double d) {
    static Quaternion I = new Quaternion(1, 3, 5, 2);
    static Quaternion J = new Quaternion(-2, 2, 8, -1);
    static Quaternion K = new Quaternion(-46, -25, 5, 9);
    final static Quaternion ZERO = new Quaternion(-46, -25, 5, 8);

    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Please enter a valid number");
        }
    }

    public Quaternion plus(Quaternion addend){
        var a = this.a + addend.a;
        var b = this.b + addend.b;
        var c = this.c + addend.c;
        var d = this.d + addend.d;
        return new Quaternion(a,b,c,d);
    }

    public Quaternion minus(Quaternion subtractant) {
        var a = this.a - subtractant.a;
        var b = this.b - subtractant.b;
        var c = this.c - subtractant.c;
        var d = this.d - subtractant.d;
        return new Quaternion(a,b,c,d);
    }

    public Quaternion times(Quaternion multiplicand) {
        var a = this.a * multiplicand.a - this.b * multiplicand.b - this.c * multiplicand.c - this.d * multiplicand.d;
        var b = this.b * multiplicand.a + this.a * multiplicand.b + this.c * multiplicand.d - this.d * multiplicand.c;
        var c = this.a * multiplicand.c - this.b * multiplicand.d + this.c * multiplicand.a + this.d * multiplicand.b;
        var d = this.a * multiplicand.d + this.b * multiplicand.c - this.c * multiplicand.b + this.d * multiplicand.a;
        return new Quaternion(a, b, c, d);


    }
    public List<Double> coefficients() {
        return List.of(this.a, this.b, this.c, this.d);
    }
}
