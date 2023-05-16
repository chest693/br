package kr.or.chest.br.receipt.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import kr.or.chest.br.receipt.dto.ReceiptDto;
import kr.or.chest.br.receipt.dto.FileDownloadDto;
import kr.or.chest.br.common.CamelCaseMap;
import org.apache.ibatis.annotations.Param;
import kr.or.chest.br.receipt.dto.LoginDto;
import kr.or.chest.br.receipt.dto.UserDto;

@Mapper
public interface ReceiptMapper {

	UserDto selectLoginEMPLInfo(LoginDto login);

	String selectRceptNo();
	
	CamelCaseMap classProgrm(@Param("progrm") String progrm);

	CamelCaseMap classAcnut(@Param("acnutNo") String acnutNo);
	
	List<CamelCaseMap> selectProgrm(@Param("dpstnId") String dpstnId);

	List<CamelCaseMap> selectAccount(@Param("dpstnId") String dpstnId, @Param("progrmCode") String progrmCode);
	
	List<CamelCaseMap> selectArea(@Param("bhfCode") String bhfCode);
	
	void rceptInsert(ReceiptDto receiptdto);

	void rceptUpdate(ReceiptDto receiptdto);
	
	List<CamelCaseMap> selectReceiptList(ReceiptDto receiptdto);

	List<CamelCaseMap> selectDepositList(ReceiptDto receiptdto);

	List<CamelCaseMap> selectTransList(ReceiptDto receiptdto);

	CamelCaseMap selectReceiptDetail(ReceiptDto receiptdto);

	void getCnfirmNo(ReceiptDto receiptdto);
	
	Integer issueUpdate(ReceiptDto receiptdto);
	
	Integer delReceiptFile(ReceiptDto receiptdto);

	Integer receiptDelete(ReceiptDto receiptdto);	

	Integer updateStats(ReceiptDto receiptdto);	
	
	Integer printCntUpdate(@Param("rceptNo") String rceptNo, @Param("sptdpstnCd") String sptdpstnCd);
	
	CamelCaseMap selectRceptPrint(@Param("rceptNo") String rceptNo, @Param("sptdpstnCd") String sptdpstnCd);

	FileDownloadDto getFile(@Param("rceptNo") String rceptNo, @Param("sptdpstnCd") String sptdpstnCd);

	FileDownloadDto getFile1(@Param("rceptNo") String rceptNo, @Param("sptdpstnCd") String sptdpstnCd);
	
	FileDownloadDto getTotalFile(@Param("rceptNo") String rceptNo, @Param("sptdpstnCd") String sptdpstnCd);
	
	String checkIhidnumBizrno(@Param("ihidnumBizrno") String ihidnumBizrno);
	
	CamelCaseMap selectBhfInfo(@Param("bhfCode") String bhfCode);
	
	Integer loginSuccess(@Param("dpstnId") String dpstnId);

	Integer pwdFailCntUpdate(@Param("dpstnId") String dpstnId);
	
	Integer lockAtUpdate(@Param("dpstnId") String dpstnId);
	
}
