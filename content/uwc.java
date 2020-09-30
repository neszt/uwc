import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class uwc {


	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		// TODO Auto-generated method stub
		final HashMap<String, Integer> hash = new HashMap<String, Integer>();

		InputStreamReader isr = new InputStreamReader(System.in);
		BufferedReader br = new BufferedReader(isr);

		String line;
		Pattern p = Pattern.compile("[a-z']+", Pattern.CASE_INSENSITIVE);

		while ((line = br.readLine()) != null) {
			Matcher m = p.matcher(line);
			while (m.find()) {
				final String w = m.group();

				Integer v = hash.get(w);
				if (v == null) {
					v = 1;
				} else {
					v++;
				}
				hash.put(w, v);
			}
		}

		ArrayList<String> words = new ArrayList<String>();

		for (Map.Entry<String, Integer> e : hash.entrySet()) {
			words.add(e.getKey());
		}

		Collections.sort(words,  new Comparator<String>() {
			@Override
			public int compare(String o1, String o2) {
				// TODO Auto-generated method stub
				int diff = hash.get(o1) - hash.get(o2);
				if (diff != 0) {
					return diff;
				}

				return o1.compareTo(o2);
			}
		});

		OutputStreamWriter osr = new OutputStreamWriter(System.out);
		BufferedWriter bw = new BufferedWriter(osr);

		for (String s : words) {
			bw.write(s + " " + hash.get(s).toString() + "\n");
		}

		bw.flush();
	}

}
