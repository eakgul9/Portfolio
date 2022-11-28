using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class ReplayBtn : MonoBehaviour
{

    public void ReplayLevel()
    {
        SceneManager.LoadScene("Library");
    }

    public void quitLevel()
    {
        SceneManager.LoadScene("Menu");
    }
}
