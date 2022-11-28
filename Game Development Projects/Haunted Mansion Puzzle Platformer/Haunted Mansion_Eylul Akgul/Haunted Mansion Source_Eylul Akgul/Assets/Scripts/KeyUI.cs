using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Bolt;
using Ludiq;
using TMPro;
using UnityEngine.UI;

public class KeyUI : MonoBehaviour
{
    public Sprite keyFull;

    public void keyCollected()
    {
        if((bool)Variables.ActiveScene.Get("HasKey") == true)
        {
            Image img = this.GetComponent<Image>();
            img.sprite = keyFull;
 
        }
    }
}

