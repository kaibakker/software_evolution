
public class HelloWorld {
  public static void main(String[] args) {
    // Een comment
    if(args[0] == "Hoi") {
      System.out.println("snor");
    }
    
    System.out.println("Hello World");
  }
  
  public static void main2(String[] args) {
    // Een comment
    System.out.println("Hello World");
  }
  public static String bla(int n) {
    if(n%2 == 0) {
      if(n%4 == 0) {
        
        return "vierfout";
      } else {
        return "tweefout";
      }
    } else {
      return "eenfout";
    }
  }
  
  
  public static String bla2(int n) {
    if(n%2 == 0) {
      if(n%4 == 0) {
        
        return "vierfout";
      } else {
        return "tweefout";
      }
    } else {
      return "eenfout";
    }
  }
  
  
  public static String bla3(int n) {
    if(n%2 == 0) {
      if(n%4 == 0) {
        
        return "vierfout";
      } else {
        return "tweefout";
      }
    } else {
      return "eenfout";
    }
  }
}
