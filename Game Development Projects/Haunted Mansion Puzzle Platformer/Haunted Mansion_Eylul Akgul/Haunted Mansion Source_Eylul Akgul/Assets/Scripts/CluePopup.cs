using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Bolt;
using Ludiq;

public class CluePopup : MonoBehaviour
{
    public GameObject clue;
    public GameObject clueUI;

    void Start()
    {
        clue.SetActive(false);
        if (clueUI) clueUI.SetActive(false);
    }

    private void OnTriggerEnter2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            clue.SetActive(true);
            if (clueUI) clueUI.SetActive(true);
            Variables.ActiveScene.Set("ClueIsActive", true);
        }
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        if (collision.CompareTag("Player"))
        {
            clue.SetActive(false);
            Variables.ActiveScene.Set("ClueIsActive", false);
        }
    }
}
