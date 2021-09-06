import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;
import java.util.Scanner;

public class HtmlReader {

	/*
	 * 파일 읽기 정리
	 * 
	 * 방법 4가지
	 * 1. FileReader
	 * 2. BufferedReader
	 * 3. Scanner
	 * 4. Files
	 */
	
	public static void main(String[] args) {
		
//		readFileEx();
		
		readFileHtml();
	}

	private static void readFileHtml() {
		// 문제없이 html 파일도 읽어짐
		
		try {
			byte[] bytes = Files.readAllBytes(Paths.get("emailPage.html"));
			
			System.out.println(new String(bytes));
			
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void readFileEx() {
		// FileReader
//		readFileEx1();
		
		// BufferedReader
//		readFileEx2();
//		readFileEx3();
		
		// Scanner
//		readFileEx4();
//		readFileEx5();
		
		// Files
		readFileEx6();
//		readFileEx7();
//		readFileEx8();
	}

	private static void readFileEx8() {
		// readString 예제 -> 이건 안됨 java 11 부터 
		
//		String str = Files.readString(Paths.get("test.txt"));
//		System.out.println(str);
		
	}

	private static void readFileEx7() {
		// readAllBytes 예제
		try {
			byte[] bytes = Files.readAllBytes(Paths.get("test.txt"));
			
			System.out.println(new String(bytes));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void readFileEx6() {
		/*
		 * java.nio.file.Files 클래스는 Java 7 이후부터 사용할 수 있음
		 * Files 클래스는 모두 static 메소드로 구성이 되었음
		 * Files 클래스를 이용하면, 
		 * 텍스트 파일 내용 전체를 List나 배열, String에 쉽게 담을 수 있음
		 */
		
		// readAllLines 예제
		List<String> lines;
		try {
			lines = Files.readAllLines(Paths.get("test.txt"));

			System.out.println(lines);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}

	private static void readFileEx5() {
		
		// Scanner.nextLine() 예제
		// 라인 단위로 텍스트 파일을 읽을 수 있음
		try (Scanner scanner = new Scanner(new File("test.txt"))) {
			
			while (scanner.hasNextLine()) {
				String str = scanner.nextLine();
				System.out.println(str);
			}
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
		
	}

	private static void readFileEx4() {
		/*
		 * Scanner 클래스를 이용하면 
		 * 파일의 텍스트를 delimiter를 이용하여 잘라서 읽을 수 있음
		 * (기본 delimiter는 포함한 공백('\t', '\f', '\r', '', '\n'))
		 */
		
		// Scanner.next() 사용, 기본 delimiter인 공백으로 구분된 문자열 단위로 텍스트 파일 읽기
		try (Scanner scanner = new Scanner(new File("test.txt"))) {
		
			while (scanner.hasNext()) {
				String str = scanner.next();
				System.out.println(str);
			}
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		}
	}

	private static void readFileEx3() {
		// Java 11 이후부터는 FileReader에서 인코딩을 지정할 수 있음
		
		try (BufferedReader reader = new BufferedReader(
				new InputStreamReader(new FileInputStream("test.txt"), "UTF-8")
		)) {
			
			String str;
			while((str = reader.readLine()) != null) {
				System.out.println(str);
			}
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
				
	}

	private static void readFileEx2() {
		/*
		 * buffer를 사용하기 때문에 FileReader보다 좀 더 효율적으로 파일을 읽어올 수 있음
		 * 두번째 파라미터로 buffer 사이즈를 지정할 수 있ㅇ므
		 * 입력 단위 byte 기본 buffer 사이즈 8kb
		 */
		
		// 16kb로 만드는 예제 
		try (BufferedReader reader = new BufferedReader(
				new FileReader("test.txt"),
				16 * 1024
		)) {
		
			String str;
			while((str = reader.readLine()) != null) {
				System.out.println(str);
			}
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private static void readFileEx1() {
		/*
		 *  read() 메소드를 이용해서 char를 한 글자씩 읽어올 수 있음
		 *  더 이상 읽을 글자가 없으면 -1 리턴 
		 */
		
		try (FileReader reader = new FileReader("test.txt")) {
			
			int ch;
			while((ch = reader.read()) != -1) {
				System.out.print((char) ch);
			}
			
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
}
