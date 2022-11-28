using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Bolt;
using Ludiq;

public class CollectKeyBtn : MonoBehaviour
{
    public GameObject mainMsg;

    public KeyUI keyUI;

    public void CollectKey()
    {
        this.gameObject.transform.parent.gameObject.SetActive(false);
        Variables.ActiveScene.Set("HasKey", true);
        Variables.ActiveScene.Set("ClueIsActive", false);
        mainMsg.SetActive(false);

        keyUI.keyCollected();
    }
}
