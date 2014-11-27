
public class HelloWorld {

    
    public static boolean contains(int[] a, int b){
      for (int i : a) {
        if (i==b) {
           b += 1;
           b = b - 1;
           
           b *= 1;
           b /= 1;
           System.out.println(b);
           
           System.out.println(a);
           int j = 4;
           for(;i <= j;) {
             System.out.println(a);
             j ++;
           }
           
           i = b * 3;
           
          return true;
        }
      }
      
      for(int k = 0; k < 2; k ++) {
        System.out.println(k);
      }
      return false; 
    }
 
}
