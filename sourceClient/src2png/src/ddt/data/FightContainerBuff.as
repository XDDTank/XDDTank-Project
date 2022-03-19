// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.FightContainerBuff

package ddt.data
{
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import ddt.view.tips.BuffTipInfo;
    import ddt.manager.LanguageMgr;
    import __AS3__.vec.*;

    public class FightContainerBuff extends FightBuffInfo implements Disposeable 
    {

        private var _buffs:Vector.<FightBuffInfo> = new Vector.<FightBuffInfo>();

        public function FightContainerBuff(_arg_1:int, _arg_2:int=2)
        {
            super(_arg_1);
            type = _arg_2;
        }

        public function addFightBuff(_arg_1:FightBuffInfo):void
        {
            this._buffs.push(_arg_1);
        }

        public function get tipData():Object
        {
            var _local_1:BuffTipInfo = new BuffTipInfo();
            if (type != BuffType.Pay)
            {
                if (type == BuffType.CONSORTIA)
                {
                    _local_1.isActive = true;
                    _local_1.name = LanguageMgr.GetTranslation("tank.view.buff.consortiaBuff");
                    _local_1.isFree = false;
                    _local_1.linkBuffs = this._buffs;
                }
                else
                {
                    if (type == BuffType.FREE_CONTINUE)
                    {
                        _local_1.isActive = true;
                        _local_1.name = LanguageMgr.GetTranslation("ddt.vip.GrowthRuleView.freeContinue");
                        _local_1.isFree = false;
                        _local_1.linkBuffs = this._buffs;
                    }
                    else
                    {
                        _local_1.isActive = true;
                        _local_1.name = LanguageMgr.GetTranslation("tank.view.buff.cardBuff");
                        _local_1.isFree = false;
                        _local_1.linkBuffs = this._buffs;
                    };
                };
            };
            return (_local_1);
        }

        public function dispose():void
        {
            this._buffs.length = 0;
        }


    }
}//package ddt.data

