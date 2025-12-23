import requests
from bs4 import BeautifulSoup
import base64
from urllib.parse import urljoin, urlparse
import re

def encode_file_to_base64(url):
    try:
        data = requests.get(url).content
        ext = url.split(".")[-1].lower()
        if ext in ["woff2", "woff", "ttf", "otf"]:
            mime_type = f"font/{ext}"
        elif ext in ["png", "jpg", "jpeg", "gif", "svg"]:
            mime_type = f"image/{ext if ext != 'jpg' else 'jpeg'}"
        elif ext in ["mp4", "webm", "ogg"]:
            mime_type = f"video/{ext}"
        else:
            mime_type = "application/octet-stream"
        return f"data:{mime_type};base64,{base64.b64encode(data).decode()}"
    except Exception as e:
        print(f"Failed to encode {url}: {e}")
        return url

def embed_resources(url, output_file="full_page.html"):
    response = requests.get(url)
    response.raise_for_status()
    soup = BeautifulSoup(response.text, "html.parser")

    # Embed images
    for img in soup.find_all("img"):
        src = img.get("src")
        if src:
            img_url = urljoin(url, src)
            img["src"] = encode_file_to_base64(img_url)

    # Embed CSS
    for link in soup.find_all("link", rel="stylesheet"):
        href = link.get("href")
        if href:
            css_url = urljoin(url, href)
            try:
                css_data = requests.get(css_url).text

                # Embed fonts in CSS
                def font_replacer(match):
                    font_url = urljoin(css_url, match.group(1))
                    return f"url({encode_file_to_base64(font_url)})"

                css_data = re.sub(r'url\(([^)]+)\)', font_replacer, css_data)

                style_tag = soup.new_tag("style")
                style_tag.string = css_data
                link.replace_with(style_tag)
            except Exception as e:
                print(f"Failed to embed CSS {css_url}: {e}")

    # Embed JS
    for script in soup.find_all("script", src=True):
        js_url = urljoin(url, script["src"])
        try:
            js_data = requests.get(js_url).text
            script.attrs.pop("src", None)
            script.string = js_data
        except Exception as e:
            print(f"Failed to embed JS {js_url}: {e}")

    # Embed inline styles with background images
    for tag in soup.find_all(style=True):
        style_content = tag["style"]
        urls = re.findall(r'url\(([^)]+)\)', style_content)
        for u in urls:
            clean_url = u.strip(' "\'')
            full_url = urljoin(url, clean_url)
            style_content = style_content.replace(u, encode_file_to_base64(full_url))
        tag["style"] = style_content

    # Save the final HTML
    with open(output_file, "w", encoding="utf-8") as f:
        f.write(str(soup))

    print(f"Saved fully self-contained page to {output_file}")

# Example usage:
embed_resources("https://example.com", "example_full.html")