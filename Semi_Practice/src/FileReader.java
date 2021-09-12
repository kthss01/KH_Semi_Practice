import java.io.File;

public class FileReader {

	public static void main(String[] args) {
		// 경로 정리
//		File curDir = new File("test");
//		
//		System.out.println("절대 경로 : " + curDir.getAbsolutePath());
		
		
		// 파일목록 가져오기
		
		String path = "resources/images";
		
		File dir = new File(path);
		
		File[] fileList = dir.listFiles();
		
		for (File file : fileList) {
			System.out.println(file.getName());
		}
	}
	
}
