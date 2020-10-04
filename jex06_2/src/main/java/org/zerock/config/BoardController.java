package org.zerock.config;

import java.awt.PageAttributes.MediaType;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.zerock.domain.BoardAttachVO;
import org.zerock.domain.BoardVO;
import org.zerock.domain.Criteria;
import org.zerock.domain.CustomUser;
import org.zerock.domain.PageDTO;
import org.zerock.service.BoardService;

import lombok.AllArgsConstructor;
import lombok.extern.log4j.Log4j;

@Controller
@Log4j
@RequestMapping("/board/*")
@AllArgsConstructor
public class BoardController {

	private BoardService service;

	/*
	 * @GetMapping("/list") public void list(Model model) {
	 * 
	 * log.info("list");
	 * 
	 * model.addAttribute("list", service.getList());
	 * 
	 * }
	 */

	private void deleteFiles(List<BoardAttachVO> attachList) {

		if (attachList == null || attachList.size() == 0) {
			return;
		}

		log.info("delete attach files.....");
		log.info(attachList);

		attachList.forEach(attach -> {
			try {
				Path file = Paths.get(
						"C:\\upload\\" + attach.getUploadPath() + "\\" + attach.getUuid() + "_" + attach.getFileName());

				Files.deleteIfExists(file);

				log.info("Files.deleteIfExists(file): " + file);
				if (Files.probeContentType(file).startsWith("image")) {

					Path thumbNail = Paths.get("C:\\upload\\" + attach.getUploadPath() + "\\s_" + attach.getUuid() + "_"
							+ attach.getFileName());

					Files.delete(thumbNail);
				}
			} catch (IOException e) {
				// TODO Auto-generated catch block
				log.error("delete file error" + e.getMessage());
				// e.printStackTrace();
			} // end catch

		}); // end foreach
	}

	@GetMapping(value = "/getAttachList", produces = org.springframework.http.MediaType.APPLICATION_JSON_UTF8_VALUE)
	@ResponseBody
	public ResponseEntity<List<BoardAttachVO>> getAttachList(Long bno) {

		log.info("getAttachList " + bno);

		return new ResponseEntity<List<BoardAttachVO>>(service.getAttachList(bno), HttpStatus.OK);
	}

	@GetMapping("/list")
	public void list(Criteria cri, Model model) {

		log.info("list: " + cri);
		model.addAttribute("list", service.getList(cri));
		// model.addAttribute("pageMaker", new PageDTO(cri, 123));

		int total = service.getTotal(cri);

		log.info("total: " + total);

		model.addAttribute("pageMaker", new PageDTO(cri, total));

	}

	@GetMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public void register() {

		log.info("register");

	}

	@PostMapping("/register")
	@PreAuthorize("isAuthenticated()")
	public String register(BoardVO board, RedirectAttributes rttr) {
		log.info("=================");

		log.info("register: " + board);

		if (board.getAttachList() != null) {
			board.getAttachList().forEach(attach -> log.info(attach));
		}

		log.info("=============");

		service.register(board);

		// 일회성 데이터 전달(등록번호)
		rttr.addFlashAttribute("result", board.getBno());

		return "redirect:/board/list";
	}

	@GetMapping({ "/get", "/modify" })
	public void get(@RequestParam("bno") Long bno, Model model, @ModelAttribute("cri") Criteria cri) {

		log.info("/get or modify");

		model.addAttribute("board", service.get(bno));
	}

	@PreAuthorize("principal.username == #board.writer")
	@PostMapping("/modify")
	public String modify(BoardVO board, RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {

		log.info("modify: " + board);

		if (service.modify(board)) {
			rttr.addFlashAttribute("result", "success");
		}

		/*
		 * rttr.addAttribute("pageNum", cri.getPageNum()); rttr.addAttribute("amount",
		 * cri.getAmount()); rttr.addAttribute("type", cri.getType());
		 * rttr.addAttribute("keyword", cri.getKeyword());
		 */
		return "redirect:/board/list" + cri.getListLink();
	}

	@PreAuthorize("principal.username == #writer")
	@PostMapping("/remove")
	public String remove(@RequestParam("bno") Long bno, @RequestParam("writer") String writer, Criteria cri,
			RedirectAttributes rttr, Authentication authentication) {

		log.info("===================================");
		log.info("writer: " + writer);
		log.info("===================================");
		log.info(authentication);

		log.info(authentication.getPrincipal());

		CustomUser user = (CustomUser) authentication.getPrincipal();

		log.info("===================================");
		log.info(user.getUsername());
		log.info("===================================");

		log.info("remove..." + bno);

		List<BoardAttachVO> attachList = service.getAttachList(bno);

		if (service.remove(bno)) {

			// delete Attach Files
			deleteFiles(attachList);

			rttr.addFlashAttribute("result", "success");
		}

		return "redirect:/board/list" + cri.getListLink();
	}
	/*
	 * @PreAuthorize("principal.username == #writer")
	 * 
	 * @PostMapping("/remove") public String remove(@RequestParam("bno") Long bno,
	 * RedirectAttributes rttr, @ModelAttribute("cri") Criteria cri) {
	 * 
	 * log.info("remove...." + bno);
	 * 
	 * List<BoardAttachVO> attachList = service.getAttachList(bno);
	 * 
	 * if (service.remove(bno)) {
	 * 
	 * // delete Attach Files deleteFiles(attachList);
	 * 
	 * rttr.addFlashAttribute("result", "success"); }
	 * 
	 * 
	 * rttr.addAttribute("pageNum", cri.getPageNum()); rttr.addAttribute("amount",
	 * cri.getAmount()); rttr.addAttribute("type", cri.getType());
	 * rttr.addAttribute("keyword", cri.getKeyword());
	 * 
	 * return "redirect:/board/list" + cri.getListLink(); }
	 */
}
