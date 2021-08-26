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
    public  class AdoptPetCondition:BaseCondition
    {
        public AdoptPetCondition(BaseQuest quest, QuestConditionInfo info, int value) : base(quest, info, value) { }
        public override void AddTrigger(Game.Server.GameObjects.GamePlayer player)
        {
            player.AdoptPetEvent += new GamePlayer.PlayerAdoptPetEventHandle(player_AdoptPet);
        }

        void player_AdoptPet()
        {
            if (Value > 0)
            {
                Value--;
            }
        }

        public override void RemoveTrigger(GamePlayer player)
        {
            player.AdoptPetEvent -= new GamePlayer.PlayerAdoptPetEventHandle(player_AdoptPet);
        }

        public override bool IsCompleted(GamePlayer player)
        {
            return Value <= 0;
        }
    }
}
