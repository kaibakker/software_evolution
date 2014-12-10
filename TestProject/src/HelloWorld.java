
public class HelloWorld {
    public static int sumOfSquares(int[] numbers) {
      int len = numbers.length;
      int sum = 0;
      for(int i = 0; i != len; i += 1) {
        sum += numbers[i] * numbers[i];
      }
      
      return sum;
    }
    
    // 0
    public static int somVanKwadraten(int[] getallen) {
      int lengte = getallen.length;
      int som = 0;
      for(int j = 0; j != lengte; j += 1) {
        som += getallen[j] * getallen[j];
      }
      
      return som;
    }
    
    // 0.3
    public static int sumOfCubes(int[] numbers) { 
      
      int sum = 0;
      for(int i = 0; i != numbers.length; i += 1) {
        sum += numbers[i] * numbers[i] * numbers[i];
      }
      
      return sum;
    }
    
    // 0.1
    public static int sum(int[] numbers) {
      int lengte = numbers.length;
      int sum = 0;
      for(int i = 0; i != lengte; i += 1) {
        sum += numbers[i];
      }
      
      return sum;
    }
}


