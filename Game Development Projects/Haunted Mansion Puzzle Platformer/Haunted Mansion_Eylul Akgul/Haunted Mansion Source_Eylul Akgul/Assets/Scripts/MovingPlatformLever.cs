using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Bolt;
using Ludiq;

public class MovingPlatformLever : MonoBehaviour
{
    public MovingPlatform plat;
    public SpriteRenderer spriteRenderer;
    public Sprite leverPushed;
    public Sprite leverNeutral;

    private void OnTriggerEnter2D(Collider2D collision)
    {
        plat.toggle();
        spriteRenderer.sprite = leverPushed;
    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        plat.deactivate();
        spriteRenderer.sprite = leverNeutral;
    }
}
