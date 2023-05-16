package kr.or.chest.br.receipt.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class FileDownloadDto implements Serializable {
	private String rceptNo;
	private String realFileNm;
	private String newFileNm;
	private String filePath;
	private String realFileNm1;
	private String newFileNm1;
	private String filePath1;
}
