package main.compression;

import java.util.*;

import java.io.ByteArrayOutputStream; // Optional

/**
 * Huffman instances provide reusable Huffman Encoding Maps for
 * compressing and decompressing text corpi with comparable
 * distributions of characters.
 */
public class Huffman {
    
    // -----------------------------------------------
    // Construction
    // -----------------------------------------------

    private HuffNode trieRoot;
    // TreeMap chosen here just to make debugging easier
    private TreeMap<Character, String> encodingMap;
    // Character that represents the end of a compressed transmission
    private static final char ETB_CHAR = 23;
    
    /**
     * Creates the Huffman Trie and Encoding Map using the character
     * distributions in the given text corpus
     * 
     * @param corpus A String representing a message / document corpus
     *        with distributions over characters that are implicitly used
     *        throughout the methods that follow. Note: this corpus ONLY
     *        establishes the Encoding Map; later compressed corpi may
     *        differ.
     */
    public Huffman (String corpus) {
    	Map <Character, Integer>frequency = this.frequencyMapMaker(corpus);
    	PriorityQueue<HuffNode> huffNodes = this.priorityQueueMaker(frequency);
    	this.huffmanTrieMaker(huffNodes);
    	this.encodingMap = new TreeMap<>();
    	this.encodingMapMaker(this.trieRoot, "");
    }
    
    /**
     * Creates the Frequency Map of the characters in the given string.
     * 
     * @param corpus String that we are iterating through
     * @return frequency the Hash Map of characters as the keys and 
     * 		   their frequencies as the values.
     */
    private Map<Character, Integer> frequencyMapMaker(String corpus){
    	Map<Character, Integer> frequency = new HashMap<>();
    	for(int c = 0; c < corpus.length(); c++) {
    		char letter = corpus.charAt(c);
    		if(!frequency.containsKey(letter)) {
    			frequency.put(letter, 1);
    		}
    		else {
        		frequency.put(letter, frequency.get(letter) + 1);
        	}
        }
    	frequency.put(ETB_CHAR, 1);
    	return frequency;
    }
    
    /**
     * Creates the Priority Queue when given a map of character frequencies.
     * 
     * @param frequency the Hash Map of characters and their frequencies.
     * @return huffNodes the Priority Queue made up of HuffNodes.
     */
    private PriorityQueue<HuffNode> priorityQueueMaker(Map<Character, Integer> frequency){
    	PriorityQueue<HuffNode> huffNodes = new PriorityQueue<>();
    	for(Map.Entry<Character, Integer> frequencies : frequency.entrySet()) {
    			HuffNode current = new HuffNode(frequencies.getKey(), frequencies.getValue());
    			huffNodes.add(current);
			}
    	return huffNodes;
    }
    
    /**
     * Creates the Huffman Trie when given the Priority Queue filled with nodes.
     * 
     * @param huffNodes Priority Queue of HuffNodes.
     */
    private void huffmanTrieMaker(PriorityQueue<HuffNode> huffNodes) {
    	while(huffNodes.size() > 1) {
    		HuffNode first = huffNodes.poll();
    		HuffNode second = huffNodes.poll();
    		HuffNode parent = new HuffNode(first.character, first.count + second.count);
    		parent.zeroChild = first;
    		parent.oneChild = second;
    		huffNodes.add(parent);
    	}
    	this.trieRoot = huffNodes.poll();
    }
    
    /**
     * Creates the Encoding Map, when given the current HuffNode and the encoding string.
     * 
     * @param current HuffNode representing the current Node we are traversing on.
     * @param encoding String that we are collecting for each Character/ Key.
     */
    private void encodingMapMaker(HuffNode current, String encoding){
    	if(current.isLeaf()) {
    		this.encodingMap.put(current.character, encoding);
    		return;
    	}
    	encodingMapMaker(current.zeroChild, encoding + "0");
    	encodingMapMaker(current.oneChild, encoding + "1");
    }
    
    // -----------------------------------------------
    // Compression
    // -----------------------------------------------
    
    /**
     * Compresses the given String message / text corpus into its Huffman coded
     * bitstring, as represented by an array of bytes. Uses the encodingMap
     * field generated during construction for this purpose.
     * 
     * @param message String representing the corpus to compress.
     * @return {@code byte[]} representing the compressed corpus with the
     *         Huffman coded bytecode. Formatted as:
     *         (1) the bitstring containing the message itself, (2) possible
     *         0-padding on the final byte.
     */
    public byte[] compress (String message) {
    	String encodedMessage = this.bitStringMaker(message);
    	return byteMaker(encodedMessage).toByteArray();
    }
    
    /**
     * Creates the bit string representation of a given message using the encoding
     * map.
     * 
     * @param message String that we are iterating through.
     * @return bitString String that represents the encoded message.
     */
    private String bitStringMaker(String message) {
    	String bitString = "";
    	for(int c = 0; c < message.length(); c++) {
    		bitString += encodingMap.get(message.charAt(c));
    	}
    	bitString += encodingMap.get(ETB_CHAR);
    	while(bitString.length() % 8 != 0) {
    		bitString += "0";
    	}
    	return bitString;
    }
    
    /**
     * Creates the Byte Array Output Stream when given the encoded bit representation of 
     * a message.
     * 
     * @param encodedMessage String that has the bit representation of the message to 
     * 		  compress.
     * @return output ByteArrayOutputStream containing 1 byte values from the encoded 
     * 		   message.
     */
    private ByteArrayOutputStream byteMaker(String encodedMessage) {
    	ByteArrayOutputStream output = new ByteArrayOutputStream();
    	while(encodedMessage.length() != 0) {
    		String eightBits = encodedMessage.substring(0, 8);
    		output.write((byte) Integer.parseInt(eightBits, 2));
    		encodedMessage = encodedMessage.substring(8);
    	}
    	return output;
    }
    
    // -----------------------------------------------
    // Decompression
    // -----------------------------------------------
    
    /**
     * Decompresses the given compressed array of bytes into their original,
     * String representation. Uses the trieRoot field (the Huffman Trie) that
     * generated the compressed message during decoding.
     * 
     * @param compressedMsg {@code byte[]} representing the compressed corpus with the
     *        Huffman coded bytecode. Formatted as:
     *        (1) the bitstring containing the message itself, (2) possible
     *        0-padding on the final byte.
     * @return Decompressed String representation of the compressed bytecode message.
     */
    public String decompress (byte[] compressedMsg) {
    	String bitString = "";
	    for (int i = 0; i < compressedMsg.length; i++) {
	    	String byteConverter = String.format("%8s", Integer.toBinaryString(compressedMsg[i] & 0xff)).replace(" " , "0");
	    	bitString += byteConverter;
	    }
	    return decoder(trieRoot, bitString, "", 0);
    }
    
    /**
     * Decodes the given Bit String when given the current HuffNode, the bit string the
     * decoded message collected so far and the index we are on.
     * 
     * @param current HuffNode representing the current Node we are traversing on.
     * @param bitString String of bits representing the message to decode.
     * @param decodedMessage String that has the character representation of the bitString.
     * @param index int the current index we are looking at from the bitString.
     * @return decodedMessage String that includes the character representation of the bitString.
     */
    private String decoder(HuffNode current, String bitString, String decodedMessage, int index) {
    	if(current.isLeaf()) {
    		if(current.character == ETB_CHAR) {
    			return decodedMessage;
    		}
    		decodedMessage += current.character;
    		current = this.trieRoot;
    	}
    	if(bitString.charAt(index) == '0') {
    		return decoder(current.zeroChild, bitString, decodedMessage, index + 1);
    	}
    	else {
    		return decoder(current.oneChild, bitString, decodedMessage, index + 1);
    	}
    }
    
    // -----------------------------------------------
    // Huffman Trie
    // -----------------------------------------------
    
    /**
     * Huffman Trie Node class used in construction of the Huffman Trie.
     * Each node is a binary (having at most a left (0) and right (1) child), contains
     * a character field that it represents, and a count field that holds the 
     * number of times the node's character (or those in its subtrees) appear 
     * in the corpus.
     */
    private static class HuffNode implements Comparable<HuffNode> {
        
        HuffNode zeroChild, oneChild;
        char character;
        int count;
        
        HuffNode (char character, int count) {
            this.count = count;
            this.character = character;
        }
        
        public boolean isLeaf () {
            return this.zeroChild == null && this.oneChild == null;
        }
        
        public int compareTo (HuffNode other) {
            if(this.count == other.count) {
                return this.character - other.character;
                }
            return this.count - other.count;
        }
    }
}