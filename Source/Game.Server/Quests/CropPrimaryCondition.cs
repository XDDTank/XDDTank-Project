using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using Game.Logic;
using Game.Server.GameObjects;

namespace Game.Server.Quests
{

    /// <summary>
    /// 21、通关关卡/关卡ID/回合数
    /// 触发条件：挂在客户端结算画面。
    /// </summary>
    public  class CropPrimaryCondition:BaseCondition
    {
        public CropPrimaryCondition(BaseQuest quest, QuestConditionInfo info, int value) : base(quest, info, value) { }
        public override void AddTrigger(Game.Server.GameObjects.GamePlayer player)
        {
            player.CropPrimaryEvent += new GamePlayer.PlayerCropPrimaryEventHandle(player_CropPrimary);
        }

        void player_CropPrimary()
        {            
            if (Value > 0)
            {
                Value--;
            }
        }

        public override void RemoveTrigger(GamePlayer player)
        {
            player.CropPrimaryEvent -= new GamePlayer.PlayerCropPrimaryEventHandle(player_CropPrimary);
        }

        public override bool IsCompleted(GamePlayer player)
        {
            return Value <= 0;
        }
    }
}
