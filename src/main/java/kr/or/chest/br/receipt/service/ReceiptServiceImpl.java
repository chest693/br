package kr.or.chest.br.receipt.service;

import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

import kr.or.chest.br.receipt.dto.LoginDto;
import kr.or.chest.br.receipt.dto.ReceiptDto;
import kr.or.chest.br.receipt.dto.FileDownloadDto;
import kr.or.chest.br.receipt.mapper.ReceiptMapper;
import kr.or.chest.br.common.BaseController;
import kr.or.chest.br.common.CamelCaseMap;
import kr.or.chest.br.common.Paging;
import kr.or.chest.br.common.Util;
import kr.or.chest.br.common.FileDownloadView;

import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import java.util.Calendar;
import java.util.HashMap;
import java.text.SimpleDateFormat;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import kr.or.chest.br.receipt.dto.ResultMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Value;
import kr.or.chest.br.common.CamelCaseMap;
import kr.or.chest.br.receipt.dto.UserDto;
import javax.servlet.http.HttpServletRequest;
import org.springframework.web.servlet.ModelAndView;

@Service
public class ReceiptServiceImpl extends BaseController implements ReceiptService{

	@Value("${spring.nasPath}")
	private String nasPath;
	
	@Value("${spring.allowFileExts}")
	private String allowFileExts;
	
	@Value("${spring.maxPostSize}")
	private Long maxPostSize;

	@Value("${spring.maxFileLen}")
	private int maxFileLen;

    @Autowired
    private ReceiptMapper receiptMapper;
	
	private Logger log = LoggerFactory.getLogger(this.getClass());
	
    @Override
    public ResultMap selectLoginEMPLInfo(HttpServletRequest request, LoginDto login){
    	ResultMap resultMap = new ResultMap();
    	HttpSession session = (HttpSession)request.getSession();

        UserDto userDto = receiptMapper.selectLoginEMPLInfo(login); 

    	if(userDto == null) {
	    	resultMap.setResultCode("F1");
	    	resultMap.setResultMsg("아이디가 존재하지 않거나, 비밀번호가 잘못 입력되었습니다. \n\n(※비밀번호 5회 오류 시 계정이 잠금 처리되오니 주의하세요.)");
    	} else {
            log.debug("======================================");
        	log.debug("dpstnId : " + userDto.getDpstnId() );
        	log.debug("sptdpstnCd : " + userDto.getSptdpstnCd() );
        	log.debug("sptdpstnNm : " + userDto.getSptdpstnNm() );
        	log.debug("bhfCode : " + userDto.getBhfCode() );
        	log.debug("bhfNm : " + userDto.getBhfNm() );
        	log.debug("bhfTelno : " + userDto.getBhfTelno() );
        	log.debug("passYn : " + userDto.getPassYn() );
        	log.debug("endYn : " + userDto.getEndYn() );
        	log.debug("userSeCode : " + userDto.getUserSeCode() );
        	log.debug("tryCo : " + userDto.getTryCo() );
        	log.debug("lockAt : " + userDto.getLockAt() );
        	log.debug("validEndde : " + userDto.getValidEndde() );
            log.debug("======================================");

    		if("0".equals(userDto.getPassYn())) {
    	    	resultMap.setResultCode("F2");
    	    	resultMap.setResultMsg("아이디가 존재하지 않거나, 비밀번호가 잘못 입력되었습니다. \n\n(※비밀번호 5회 오류 시 계정이 잠금 처리되오니 주의하세요.)");
    	    	
    	    	//비밀번호가 5회이상 틀릴 시 계정중지 (lockAt=Y)
    	    	if(userDto.getTryCo() >= 5) {
       	    		Integer resultCode = receiptMapper.lockAtUpdate(userDto.getDpstnId());
       	    		if (resultCode < 0) throw new RuntimeException("저장 시 문제가 발생 하였습니다.\n담당자에게 문의하세요");

        	    	resultMap.setResultMsg("로그인이 5회이상 실패하여 계정이 중지되었습니다. \n담당자에게 문의하세요");
    	    	} else {
       	    		Integer resultCode = receiptMapper.pwdFailCntUpdate(userDto.getDpstnId());
       	    		if (resultCode < 0) throw new RuntimeException("저장 시 문제가 발생 하였습니다.\n담당자에게 문의하세요");
       	    		
//        	    	resultMap.setResultMsg("로그인이 "+ (userDto.getTryCo()+1) +"회 실패하였습니다.\n5회이상 실패하면 계정이 중지됩니다.");
        	    	resultMap.setResultMsg("아이디가 존재하지 않거나, 비밀번호가 잘못 입력되었습니다. \n\n(※비밀번호 5회 오류 시 계정이 잠금 처리되오니 주의하세요.)");
    	    	}
    		} else if("0".equals(userDto.getEndYn())){
    	    	resultMap.setResultCode("F3");
    	    	resultMap.setResultMsg("사용이 만료 된 사용자입니다. \n담당자에게 문의하세요.");
    		} else if("Y".equals(userDto.getLockAt())){
    	    	resultMap.setResultCode("F4");
    	    	resultMap.setResultMsg("로그인이 5회이상 실패하여 계정이 중지되었습니다. \n담당자에게 문의하세요");
    		} else {
   	            session.setAttribute("userInfo", userDto);

   	    		Integer resultCode = receiptMapper.loginSuccess(userDto.getDpstnId());
   	    		if (resultCode < 0) throw new RuntimeException("저장 시 문제가 발생 하였습니다.\n담당자에게 문의하세요");
   	            
    	    	resultMap.setResultCode("S");
    	    	resultMap.setResultMsg("정상적으로 처리되었습니다.");
    		}
    	}
    	
    	/*
    	request.getSession().setAttribute("hello", "kimbongjin");
    	
    	log.debug("------------------------------------------------------");
    	log.debug("hello : " + request.getSession().getAttribute("hello"));
    	log.debug("------------------------------------------------------");
    	*/
    	
    	
    	return resultMap;
    }
    
    @Override
    //@ResponseBody
    public HashMap<String,Object> receiptInsert(MultipartHttpServletRequest mRequest, ReceiptDto receiptDto) {
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        String sptdpstnCd = getSessionInfo().getSptdpstnCd();
        
        String rceptNo = receiptMapper.selectRceptNo();

        CamelCaseMap ccmProgm = receiptMapper.classProgrm(receiptDto.getProgrm());
        CamelCaseMap ccmAcnut = receiptMapper.classAcnut(receiptDto.getRcpmnyAcnut());
        
        receiptDto.setRceptNo(rceptNo);
        receiptDto.setSptdpstnCd(sptdpstnCd);
        receiptDto.setStatsAt("0");
        receiptDto.setProgrmClCode(ccmProgm.getString("progrmClCode"));
        receiptDto.setProgrmCode(ccmProgm.getString("progrmCode"));
        receiptDto.setBankCode(ccmAcnut.getString("bankCode"));
        receiptDto.setIndvdLinfoProvdAgreAt("02");
        receiptDto.setRegister(dpstnId);
        
        try {
            //첨부파일
    		fileUpload(mRequest, receiptDto, bhfCode, "INS" );
            map.put("rceptNo",rceptNo);
        } catch (Exception e) {
			throw new RuntimeException(e.getMessage());
        }
		
		return map;
    	
    }
    
    @Override
    //@ResponseBody
    public HashMap<String,Object> receiptUpdate(MultipartHttpServletRequest mRequest, ReceiptDto receiptDto) {
    	HashMap<String,Object> map = new HashMap<String,Object>();
        String dpstnId = getSessionInfo().getDpstnId();
        String bhfCode = getSessionInfo().getBhfCode();
        
        CamelCaseMap ccmProgm = receiptMapper.classProgrm(receiptDto.getProgrm());
        CamelCaseMap ccmAcnut = receiptMapper.classAcnut(receiptDto.getRcpmnyAcnut());
        
        receiptDto.setProgrmClCode(ccmProgm.getString("progrmClCode"));
        receiptDto.setProgrmCode(ccmProgm.getString("progrmCode"));
        receiptDto.setBankCode(ccmAcnut.getString("bankCode"));
        receiptDto.setDpstnId(dpstnId);
        
        try {
            //첨부파일
    		fileUpload(mRequest, receiptDto, bhfCode, "UPD" );
            map.put("rceptNo",receiptDto.getRceptNo());
        } catch (Exception e) {
			throw new RuntimeException(e.getMessage());
        }
		
		return map;
    }    

    @Override
    //@ResponseBody
    public void transExec(ReceiptDto receiptDto) {
        String dpstnId = getSessionInfo().getDpstnId();

        for(ReceiptDto addReceiptDto : receiptDto.getReceiptDtoList()) {
        	if("on".equals(addReceiptDto.getTranChk())){
        		addReceiptDto.setDpstnId(dpstnId);
            	receiptMapper.updateStats(addReceiptDto);
        	}
    	}

    }    
    
    @Override
    public void fileUpload(MultipartHttpServletRequest mRequest, ReceiptDto receiptDto, String bhfCode, String type) {
		Calendar calendar = Calendar.getInstance();
		java.util.Date date = calendar.getTime();
		String yyyyMMddhhmmss = new SimpleDateFormat("yyyyMMddhhmmss").format(date);
		String yyyyMM = new SimpleDateFormat("yyyyMM").format(date);

    	String oldRealFileNm = "";
    	String oldNewFileNm = "";
    	String oldFilePath = "";
    	String oldRealFileNm1 = "";
    	String oldNewFileNm1 = "";
    	String oldFilePath1 = "";
		
    	Iterator<String> iter = mRequest.getFileNames();
    	Iterator<String> iterchk = mRequest.getFileNames();

    	String filePath = "\\"+bhfCode+"\\"+yyyyMM;
        String realFolder = nasPath + filePath+"\\";

        File dir = new File(realFolder);

        receiptDto.setSptdpstnCd(getSessionInfo().getSptdpstnCd());
        
        if (!dir.isDirectory()) {
            dir.mkdirs();
        }

    	FileDownloadDto fileInfo = receiptMapper.getTotalFile(receiptDto.getRceptNo(), getSessionInfo().getSptdpstnCd());

    	if(fileInfo != null) {
        	oldRealFileNm = fileInfo.getRealFileNm();
        	oldNewFileNm = fileInfo.getNewFileNm();
        	oldFilePath = fileInfo.getFilePath();
        	oldRealFileNm1 = fileInfo.getRealFileNm1();
        	oldNewFileNm1 = fileInfo.getNewFileNm1();
        	oldFilePath1 = fileInfo.getFilePath1();
    	}
    	
    	boolean fileFlag = false;
    	boolean fileFlag1 = false;
    	
        while(iterchk.hasNext()) {
            String chkUploadFileName = iterchk.next();
            MultipartFile chkMFile = mRequest.getFile(chkUploadFileName);
            String fileName = Util.getFileNameFromPath(chkMFile.getOriginalFilename());
            long fileSize = chkMFile.getSize(); 
            
            if(fileName != null && !fileName.equals("")) {
				//(1) 파일명 사이즈를 Check 한다.
				if (fileSize > maxPostSize * 1024 * 1024 ) {
					throw new RuntimeException( "'" + fileName + "' 파일 사이즈(" + Util.byteCalculation(Long.toString(fileSize)) + ")가  첨부 가능한 최대 사이즈(" + Util.byteCalculation(Long.toString(maxPostSize*1024*1024)) + ")를 초과합니다.");
				}
				  
				//(2) 파일명 길이를 Check 한다.
				if( fileName.length() > maxFileLen ){ //첨부파일명의 길이(byte)를 조사해서 DB에 Insert될수 있는 길이인지 검증
					throw new RuntimeException( "'" + fileName + "' 파일은 파일명이 지정된 길이(" + maxFileLen + "byte)를 초과합니다. 파일명을 줄여주세요");
				}
				  
				//(3) file 확장자를  Check 한다.       
				if( Util.isAllowExtension(fileName, allowFileExts)){
					throw new RuntimeException("'" + fileName + "' 파일은 업로드 금지된 타입의 파일입니다.");
				}
            }	
        }    	
    	
        while(iter.hasNext()) {
            String uploadFileName = iter.next();
            MultipartFile mFile = mRequest.getFile(uploadFileName);
            String originalFileName = Util.getFileNameFromPath(mFile.getOriginalFilename());
            String saveFileName = yyyyMMddhhmmss+"_"+originalFileName;

            if(originalFileName != null && !originalFileName.equals("")) {
                if("fileNm1".equals(mFile.getName())) {
                	fileFlag = true;
    	            receiptDto.setRealFileNm(originalFileName);
    	            receiptDto.setNewFileNm(saveFileName);
    	            receiptDto.setFilePath(filePath);
                }else if("fileNm2".equals(mFile.getName())) {
                	fileFlag1 = true;
    	            receiptDto.setRealFileNm1(originalFileName);
    	            receiptDto.setNewFileNm1(saveFileName);
    	            receiptDto.setFilePath1(filePath);
                }            
            	
            	try {
                	String savePath = realFolder + saveFileName; // 저장 될 파일 경로
               		mFile.transferTo(new File(savePath)); // 파일 저장
                } catch (IllegalStateException e) {
                    e.printStackTrace();
                } catch (IOException e) {
                    e.printStackTrace();
                }

            }else {
                if("fileNm1".equals(mFile.getName())) {
    	            receiptDto.setRealFileNm(oldRealFileNm);
    	            receiptDto.setNewFileNm(oldNewFileNm);
    	            receiptDto.setFilePath(oldFilePath);
                }else if("fileNm2".equals(mFile.getName())) {
    	            receiptDto.setRealFileNm1(oldRealFileNm1);
    	            receiptDto.setNewFileNm1(oldNewFileNm1);
    	            receiptDto.setFilePath1(oldFilePath1);
                }            
            }
        }
        
        if("INS".equals(type)) {
        	receiptMapper.rceptInsert(receiptDto);
        }else {
        	File file = new File(nasPath + fileInfo.getFilePath() + "\\" + fileInfo.getNewFileNm());
			if( fileFlag && file.exists()){
				file.delete();
			}
			
			File file1 = new File(nasPath + fileInfo.getFilePath1() + "\\" + fileInfo.getNewFileNm1());
			if( fileFlag1 && file1.exists()){
				file1.delete();
			}
			
        	receiptMapper.rceptUpdate(receiptDto);
        }
    }    
    
    @Override
    @ResponseBody
    public String issueSave(ReceiptDto receiptDto) {
        String bhfCode = getSessionInfo().getBhfCode();

        receiptDto.setBhfCode(bhfCode);
        receiptDto.setSptdpstnCd(getSessionInfo().getSptdpstnCd());

        receiptMapper.getCnfirmNo(receiptDto);
   		String cnfirmNo = receiptDto.getCnfirmNo();
   		Integer resultCode = receiptMapper.issueUpdate(receiptDto);
   		
   		if (resultCode < 0) throw new RuntimeException("저장 시 문제가 발생 하였습니다.\n관리자에게 문의하세요");
   		
   		return cnfirmNo;
    }
        
    @Override
    public ModelAndView fileDownload(String rceptNo, String type){
        ModelAndView mav = new ModelAndView();
        FileDownloadDto fileDownloadDto = new FileDownloadDto();
        FileDownloadView fileDownloadView = new FileDownloadView();
    	
    	if("1".equals(type)) {
    		fileDownloadDto = receiptMapper.getFile(rceptNo, getSessionInfo().getSptdpstnCd());
    	}else {
    		fileDownloadDto = receiptMapper.getFile1(rceptNo, getSessionInfo().getSptdpstnCd());
    	}
    	
    	String filePath = fileDownloadDto.getFilePath();
    	String realFileNm = fileDownloadDto.getRealFileNm();
    	String newFileNm = fileDownloadDto.getNewFileNm();
    	
        mav.setView(fileDownloadView);

    	File downloadFile = new File(nasPath + filePath + "\\"+ newFileNm);
        mav.addObject("realFileNm", realFileNm);
        mav.addObject("downloadFile", downloadFile);

        return mav;
    }

    @Override
    public ModelAndView documentDownload(String file){
        ModelAndView mav = new ModelAndView();
        FileDownloadView fileDownloadView = new FileDownloadView();

        mav.setView(fileDownloadView);

    	File downloadFile = new File(nasPath + "\\"+ file);
        mav.addObject("realFileNm", file);
        mav.addObject("downloadFile", downloadFile);

        return mav;
    }
    
    
    @Override
    //@ResponseBody
    public void delReceiptFile(String rceptNo, String type) {
        ReceiptDto receiptdto = new ReceiptDto();
        receiptdto.setRceptNo(rceptNo);
        receiptdto.setDpstnId(getSessionInfo().getDpstnId());
        receiptdto.setType(type);
        receiptdto.setSptdpstnCd(getSessionInfo().getSptdpstnCd());

    	FileDownloadDto fileInfo = receiptMapper.getTotalFile(rceptNo, getSessionInfo().getSptdpstnCd());
    	
        Integer resultCode = receiptMapper.delReceiptFile(receiptdto);
        
   		if (resultCode < 0) {
   			throw new RuntimeException("삭제 시 문제가 발생 하였습니다.\n관리자에게 문의하세요");
   		} else {
   	    	File file = new File(nasPath + fileInfo.getFilePath() + "\\" + fileInfo.getNewFileNm());
			if( "1".equals(type) && file.exists()){
				file.delete();
			} 
			
   	    	File file1 = new File(nasPath + fileInfo.getFilePath1() + "\\" + fileInfo.getNewFileNm1());
			if( "2".equals(type) && file1.exists()){
				file1.delete();
			} 
   		}
    }    

    
    @Override
    //@ResponseBody
    public void receiptDelete(ReceiptDto receiptDto) {
    	receiptDto.setDpstnId(getSessionInfo().getDpstnId());
    	
    	Integer resultCode = receiptMapper.receiptDelete(receiptDto);
   		if (resultCode < 0) {
   			throw new RuntimeException("삭제 시 문제가 발생 하였습니다.\n관리자에게 문의하세요");
   		}
    }    
    
    
}

