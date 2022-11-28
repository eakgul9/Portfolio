using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using TMPro;
using Bolt;
using Ludiq;

public class Door : MonoBehaviour
{
    public GameObject exitMsg;
    public SpriteRenderer spriteRenderer;
    public Sprite openDoor;
    
    void Start()
    {
        exitMsg.SetActive(false);
    }

    public void OnTriggerEnter2D(Collider2D collision)
    {
        Debug.Log(collision.tag);
        if (collision.CompareTag("Player"))
        {
           if((bool)Variables.ActiveScene.Get("HasKey") == true)
            {
                spriteRenderer.sprite = openDoor; 
                exitMsg.SetActive(true);
            } 
        }  

    }
}
