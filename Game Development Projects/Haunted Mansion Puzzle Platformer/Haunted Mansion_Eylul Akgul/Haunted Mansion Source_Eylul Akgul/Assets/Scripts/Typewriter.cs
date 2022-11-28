using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using Bolt;
using Ludiq;

public class Typewriter : MonoBehaviour
{
    public GameObject key;
    public GameObject error;
    public TMP_InputField inputNum;
    private string code;
    
    // Start is called before the first frame update
    void Start()
    {
        key.SetActive(false);
        error.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void CheckCode()
    {
        code = inputNum.text;
        
        if (code == "235")
        {
            key.SetActive(true);
            Variables.ActiveScene.Set("ClueIsActive", true);
        }

        else
        {
            error.SetActive(true);
        }
    }
}
