using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Bolt;
using Ludiq;

public class ClueCloseBtn : MonoBehaviour
{

    public void CloseClue()
    {
        this.gameObject.transform.parent.gameObject.SetActive(false);
        Variables.ActiveScene.Set("ClueIsActive", false);
    }
}
