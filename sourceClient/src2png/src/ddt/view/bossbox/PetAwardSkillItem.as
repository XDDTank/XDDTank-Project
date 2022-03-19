// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.view.bossbox.PetAwardSkillItem

package ddt.view.bossbox
{
    import petsBag.view.item.SkillItem;
    import flash.display.Bitmap;
    import pet.date.PetEggInfo;
    import com.pickgliss.ui.ComponentFactory;
    import pet.date.PetSkillInfo;
    import com.pickgliss.utils.ObjectUtils;

    public class PetAwardSkillItem extends SkillItem 
    {

        private var _bg:Bitmap;
        private var _eggInfo:PetEggInfo;


        override protected function initView():void
        {
            this._bg = ComponentFactory.Instance.creat("asset.awardSystem.petAward.skillBg");
            addChild(this._bg);
            width = this._bg.width;
            height = this._bg.height;
            super.initView();
        }

        public function get eggInfo():PetEggInfo
        {
            return (this._eggInfo);
        }

        public function set eggInfo(_arg_1:PetEggInfo):void
        {
            this._eggInfo = _arg_1;
            var _local_2:PetSkillInfo = new PetSkillInfo();
            _local_2.ID = this._eggInfo.ID;
            _local_2.Name = this._eggInfo.Name;
            _local_2.Description = this._eggInfo.Desc;
            _local_2.Pic = this._eggInfo.Icon;
        }

        override public function updateSize():void
        {
            if (_skillIcon)
            {
                _skillIcon.x = ((this._bg.width - 44) / 2);
                _skillIcon.y = ((this._bg.height - 44) / 2);
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            this._eggInfo = null;
            super.dispose();
        }


    }
}//package ddt.view.bossbox

