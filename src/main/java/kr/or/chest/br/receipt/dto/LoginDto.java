package kr.or.chest.br.receipt.dto;

import java.io.Serializable;

import lombok.Data;

@Data
public class LoginDto implements Serializable {

	private String id;
	private String pwd;
	private String trumny;
	
}
