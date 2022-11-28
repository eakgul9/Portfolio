using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SwitchPopUp : MonoBehaviour
{
    public GameObject prevClue;
    
    public void SwitchClue()
    {
        this.gameObject.transform.parent.gameObject.SetActive(false);
        prevClue.SetActive(true);
    }
}
