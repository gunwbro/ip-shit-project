package myBean;

public class Webtoon {
  
  private String title;
  private String genre;
  private String author;
  private String authorText;
  private String summary;

  public Webtoon() {
    title = "";
    genre = "";
    author = "";
    authorText = "";
    summary = "";
  }
  
  public String getTitle() {
    return title;
  }
  public String getGenre() {
    return genre;
  }
  public String getAuthor() {
    return author;
  }
  public String getAuthorText() {
    return authorText;
  }
  public String getSummary() {
    return summary;
  }

  public void setTitle(String arg0) {
    this.title = arg0;
  }
  public void setGenre(String arg0) {
    this.genre = arg0;
  }
  public void setAuthor(String arg0) {
    this.author = arg0;
  }
  public void setAuthorText(String arg0) {
    this.authorText = arg0;
  }
  public void setSummary(String arg0) {
    this.summary = arg0;
  }
}