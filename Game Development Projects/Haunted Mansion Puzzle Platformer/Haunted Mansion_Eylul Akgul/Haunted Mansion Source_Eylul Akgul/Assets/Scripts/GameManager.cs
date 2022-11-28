using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using TMPro;

public class GameManager : Singleton<GameManager>
{
    private int currentLevelIndex = 1;
    private int numLevelsTotal = 1;


    [Header("Text References")]
    public GameObject typewriterMsgGO;
    public GameObject keyFoundMsgGO;
    public GameObject chestMsg1GO;
    public GameObject chestMsg2GO;
    public GameObject chestMsg3GO;
    public GameObject exitMsgGO;
    public GameObject quitBtn;


    // Start is called before the first frame update
    void Start()
    {
        InitLevel();
    }

    private void InitLevel()
    {
        Debug.Log("InitLevel");

        currentLevelIndex = SceneManager.GetActiveScene().buildIndex;
        numLevelsTotal = SceneManager.sceneCountInBuildSettings;

        Debug.Log("numLevelsTotal: " + numLevelsTotal);

        typewriterMsgGO.SetActive(false);
        keyFoundMsgGO.SetActive(false);
        
        chestMsg1GO.SetActive(false);
        chestMsg2GO.SetActive(false);
        chestMsg3GO.SetActive(false);
        
        exitMsgGO.SetActive(false);

        Time.timeScale = 1.0f;

    }


    private void EndLevel()
    {
        Time.timeScale = 0.0f;
        ShowExitMsg();
    }

    private void ShowExitMsg()
    {
        exitMsgGO.SetActive(true);

        quitBtn.SetActive(true);
    }

    private void LoadLevel(int levelIndexToLoad)
    {
        SceneManager.LoadScene(levelIndexToLoad);
        SceneManager.sceneLoaded += OnSceneLoaded;
    }

    private void OnRestart()
    {
        RestartLevel();
    }

    public void RestartLevel()
    {
        Debug.Log("RestartLevel: "+ currentLevelIndex);
        LoadLevel(currentLevelIndex);
    }

    public void LoadMenu()
    {
        LoadLevel(0);
    }

    private void OnSceneLoaded(Scene scene, LoadSceneMode mode)
    {
        //Debug.Log("OnSceneLoaded");
        InitLevel();
        SceneManager.sceneLoaded -= OnSceneLoaded;
    }
}
