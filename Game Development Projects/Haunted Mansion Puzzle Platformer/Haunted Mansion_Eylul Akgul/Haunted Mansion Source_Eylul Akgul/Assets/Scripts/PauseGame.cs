using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class PauseGame : MonoBehaviour
{
    public GameObject pauseMsg;
    
    void Start()
    {
        pauseMsg.SetActive(false);
    }

    void Update()
    {
        if (Input.GetKey("escape"))
        {
            pauseMsg.SetActive(true);
            Time.timeScale = 0;
        }
    }
    
    public void Resume()
    {
        pauseMsg.SetActive(false);
        Time.timeScale = 1;
    }

}
