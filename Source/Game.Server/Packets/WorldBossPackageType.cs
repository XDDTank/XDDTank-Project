﻿namespace Game.Server.Packets
{
    public enum WorldBossPackageType
    {
        OPEN = 0,
        OVER = 1,
        CANENTER = 2,
        MOVE = 6,
        ENTER = 3,
        WORLDBOSS_EXIT = 4,
        WORLDBOSS_PLAYERSTAUTSUPDATE = 7,
        WORLDBOSS_FIGHTOVER = 8,
        WORLDBOSS_ROOM_CLOSE = 9,
        WORLDBOSS_BLOOD_UPDATE = 5,
        WORLDBOSS_RANKING = 10,
        WORLDBOSS_PLAYER_REVIVE = 11,
        WORLDBOSS_BUYBUFF = 12,
        WORLDBOSS_PRIVATE_INFO = 22,
    }
}
