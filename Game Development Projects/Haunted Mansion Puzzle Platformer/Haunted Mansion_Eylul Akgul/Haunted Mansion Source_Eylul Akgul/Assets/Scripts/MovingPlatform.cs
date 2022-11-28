using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovingPlatform : MonoBehaviour
{
    private float moveSpeed = 0.003f;

    public Transform targetPt;
    private float targetY;

    private bool isMoving = false;
    
    void Start()
    {
       targetY = targetPt.position.y;
    }

    void Update()
    {
        if (isMoving)
        {
            
            if (transform.position.y < targetY)
            {
                Vector3 newPos = transform.position;
                newPos.y += moveSpeed;

                transform.position = newPos;
            }
            else
            {
                transform.position = new Vector3(transform.position.x, targetY, transform.position.z);
                isMoving = false;
            }
        }
    }

    public void activate()
    {
        isMoving = true;
    }

    public void deactivate()
    {
        isMoving = false;
    }

    public void toggle()
    {
        isMoving = !isMoving;
    }
}
