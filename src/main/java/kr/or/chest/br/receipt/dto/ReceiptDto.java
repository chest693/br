package kr.or.chest.br.receipt.dto;

import lombok.Data;

import java.io.Serializable;
import java.util.List;
import kr.or.chest.br.common.Util;

@Data
public class ReceiptDto implements Serializable{
	private List<ReceiptDto> receiptDtoList;

	private String rceptNo;
	private String sptdpstnCd;
	private String rceptDe;
	private String dpstnSe;
	private String trumny;
	private String bankCode;
	private String rcpmnyAcnut;
	private String progrmClCode;
	private String progrmCode;
	private String dpstnArea;
	private String dpstnCn;
	private String dpstnNm;
	private String rcpnmyerNm;
	private String ihidnumBizrno;
	private String telno;
	private String email;
	private String zip;
	private String adres1;
	private String adres2;
	private String rceptReqstAt;
	private String indvdLinfoProvdAgreAt;
	private String crtfcNo;
	
	private String realFileNm;
	private String newFileNm;
	private String filePath;
	private String realFileNm1;
	private String newFileNm1;
	private String filePath1;
	private String statsAt;
	private String statsChrg;
	private String rgsde;
	private String register;
	private String registerCond;
	private String dpstnId;

	private String deleteAt;
	private int PAGE;
    private int PAGE_GROUP;
    
    private String bhfCode;
    private String cnfirmNo;
    
    
	private String rceptDeFd;
	private String rceptDeTd;
	private String progrm;
	private String type;
	private String deleteResn;

	private String tranChk;
	private String tranFt;
	private String tranEt;

	
	public String getTrumny() {
    	if(trumny==null){
    		trumny = "";
    	}else{
    		trumny = trumny.replaceAll(",", "");
    	}
		return trumny;
	}
	
	public String getRceptDe() {
    	if(rceptDe==null){
    		rceptDe = "";
    	}else{
    		rceptDe = rceptDe.replaceAll("-", "");
    	}
		return rceptDe;
	}

	public String getRceptDeFd() {
    	if(rceptDeFd==null){
    		rceptDeFd = "";
    	}else{
    		rceptDeFd = rceptDeFd.replaceAll("-", "");
    	}
		return rceptDeFd;
	}

	public String getRceptDeTd() {
    	if(rceptDeTd==null){
    		rceptDeTd = "";
    	}else{
    		rceptDeTd = rceptDeTd.replaceAll("-", "");
    	}
		return rceptDeTd;
	}
/*
	public String getDpstnNm() {
    	if(dpstnNm==null){
    		dpstnNm = "";
    	}else {
    		dpstnNm = Util.htmlEncode(dpstnNm);
    	}
		return dpstnNm;
	}

	public String getRcpnmyerNm() {
    	if(rcpnmyerNm==null){
    		rcpnmyerNm = "";
    	}else {
    		rcpnmyerNm = Util.htmlEncode(rcpnmyerNm);
    	}
		return rcpnmyerNm;
	}

	public String getDeleteResn() {
    	if(deleteResn==null){
    		deleteResn = "";
    	}else {
    		deleteResn = Util.htmlEncode(deleteResn);
    	}
		return deleteResn;
	}
	
	public String getDpstnCn() {
    	if(dpstnCn!=null){
    		dpstnCn = Util.htmlEncode(dpstnCn);
    	}
		return dpstnCn;
	}
	
	public String getRegister() {
    	if(register==null){
    		register = "";
    	} {
    		register = Util.htmlEncode(register);
    	}
		return register;
	}
*/	
	
	
	public String getStatsAt() {
    	if(statsAt==null){
    		statsAt = "";
    	}
		return statsAt;
	}
	
	public String getProgrm() {
    	if(progrm==null){
    		progrm = "";
    	}
		return progrm;
	}
	
	public String getRcpmnyAcnut() {
    	if(rcpmnyAcnut==null){
    		rcpmnyAcnut = "";
    	}
		return rcpmnyAcnut;
	}
	
	public String getDeleteAt() {
    	if(deleteAt==null){
    		deleteAt = "";
    	}
		return deleteAt;
	}
	
	public String getDpstnArea() {
    	if(dpstnArea==null){
    		dpstnArea = "";
    	}
		return dpstnArea;
	}
	
	public int getPAGE() {
    	if(PAGE==0){
    		PAGE = 1;
    	}
		return PAGE;
	}
	
	public int getPAGE_GROUP() {
    	if(PAGE_GROUP==0){
    		PAGE_GROUP = 10;
    	}
		return PAGE_GROUP;
	}
	
}


