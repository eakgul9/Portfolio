using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Bolt;
using Ludiq;

public class ChestUI : MonoBehaviour
{
    public GameObject clue;

    public void ShowClue()
    {
        clue.SetActive(true);
        Variables.ActiveScene.Set("ClueIsActive", true);
    }

    public void HideClue()
    {
        clue.SetActive(false);
        Variables.ActiveScene.Set("ClueIsActive", false);
    }
}
