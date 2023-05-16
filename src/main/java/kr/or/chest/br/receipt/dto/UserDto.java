package kr.or.chest.br.receipt.dto;

import java.io.Serializable;
import lombok.Data;

@Data
public class UserDto implements Serializable{

	private String dpstnId;
	private String sptdpstnCd;
	private String sptdpstnNm;
	private String bhfCode;
	private String bhfNm;
	private String bhfTelno;
	private String passYn;
	private String endYn;
	private String userSeCode;
	private int tryCo;
	private String lockAt;
	private String validEndde;
}
