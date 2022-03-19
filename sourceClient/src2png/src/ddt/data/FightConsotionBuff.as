// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.data.FightConsotionBuff

package ddt.data
{
    import consortion.data.ConsortionNewSkillInfo;
    import ddt.view.tips.BuffTipInfo;
    import ddt.manager.PlayerManager;
    import road7th.data.DictionaryData;
    import __AS3__.vec.Vector;
    import consortion.ConsortionModelControl;
    import __AS3__.vec.*;

    public class FightConsotionBuff 
    {

        private var _info:FightBuffInfo;

        public function FightConsotionBuff(_arg_1:FightBuffInfo)
        {
            this._info = _arg_1;
        }

        public function get tipData():Object
        {
            var _local_6:int;
            var _local_7:int;
            var _local_8:ConsortionNewSkillInfo;
            var _local_9:ConsortionNewSkillInfo;
            var _local_10:ConsortionNewSkillInfo;
            var _local_1:BuffTipInfo = new BuffTipInfo();
            var _local_2:DictionaryData = PlayerManager.Instance.Self.isLearnSkill;
            var _local_3:Vector.<int> = new Vector.<int>();
            var _local_4:int;
            if (this._info.isSelf)
            {
                _local_6 = 0;
                while (_local_6 < _local_2.length)
                {
                    _local_8 = ConsortionModelControl.Instance.model.getInfoByBuffId(_local_2[_local_6]);
                    if (((_local_8) && (_local_8.BuffType == this._info.id)))
                    {
                        _local_3.push(_local_8.BuffID);
                    };
                    _local_6++;
                };
                _local_7 = 0;
                while (_local_7 < _local_3.length)
                {
                    _local_9 = ConsortionModelControl.Instance.model.getInfoByBuffId(_local_3[_local_7]);
                    if (_local_9.BuildLevel <= PlayerManager.Instance.Self.consortiaInfo.SmithLevel)
                    {
                        _local_4 = _local_3[_local_7];
                    };
                    _local_7++;
                };
            }
            else
            {
                _local_10 = ConsortionModelControl.Instance.model.getInfoByTypeAndData(this._info.id, this._info.data);
                _local_4 = _local_10.BuffID;
            };
            var _local_5:ConsortionNewSkillInfo = ConsortionModelControl.Instance.model.getInfoByBuffId(_local_4);
            _local_1.name = _local_5.BuffName;
            _local_1.describe = _local_5.Description;
            _local_1.isActive = false;
            return (_local_1);
        }


    }
}//package ddt.data

