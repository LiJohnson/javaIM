package com.lcs.im.pojo;

public class Message extends BasePojo {
	/**
	 * serialVersionUID
	 */
	private static final long serialVersionUID = 7500808316366060633L;
	
	private String name;
	private String text;
	private String file;
	private String id;
	private String toId;
	private String head;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		if( text == null )return;
		this.text = text.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
	}

	public String getFile() {
		return file;
	}

	public void setFile(String file) {
		this.file = file;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getToId() {
		return toId;
	}

	public void setToId(String toId) {
		this.toId = toId;
	}

	public String getHead() {
		return head;
	}

	public void setHead(String head) {
		this.head = head;
	}

}