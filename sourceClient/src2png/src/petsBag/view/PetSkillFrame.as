// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//petsBag.view.PetSkillFrame

package petsBag.view
{
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.Sprite;
    import __AS3__.vec.Vector;
    import petsBag.view.item.PetSkillLevelUpItem;
    import flash.display.MovieClip;
    import ddt.view.tips.OneLineTip;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.manager.TaskManager;
    import ddt.manager.SavePointManager;
    import com.pickgliss.utils.ClassUtils;
    import ddt.manager.LanguageMgr;
    import flash.events.MouseEvent;
    import petsBag.event.PetSkillEvent;
    import ddt.manager.PlayerManager;
    import baglocked.BaglockedManager;
    import pet.date.PetSkillTemplateInfo;
    import ddt.manager.SocketManager;
    import petsBag.data.PetSkillItemInfo;
    import road7th.data.DictionaryData;
    import ddt.manager.PetSkillManager;
    import pet.date.PetInfo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class PetSkillFrame extends PetRightBaseFrame 
    {

        public static const SKILL_COUNT:int = 9;

        private var _bg2:Bitmap;
        private var _soulValueTxt:FilterFrameText;
        private var _soulTipArea:Sprite;
        private var _skillList:Vector.<PetSkillLevelUpItem>;
        private var _learnSkillTips:MovieClip;
        private var _mouseTip:OneLineTip;
        private var _titleBmp:Bitmap;
        private var _soulIcon:MovieClip;

        public function PetSkillFrame()
        {
            this.initEvent();
        }

        override protected function init():void
        {
            var _local_1:Rectangle;
            var _local_2:Point;
            super.init();
            this._titleBmp = ComponentFactory.Instance.creatBitmap("asset.petskill.title");
            addToContent(this._titleBmp);
            this._bg2 = ComponentFactory.Instance.creatBitmap("asset.petsBag.petSkillFrame.bg");
            addToContent(this._bg2);
            this._soulValueTxt = ComponentFactory.Instance.creat("petsBag.petSkillFrame.soulValuetxt");
            addToContent(this._soulValueTxt);
            this._soulIcon = ComponentFactory.Instance.creat("asset.newpetsbag.soul");
            addToContent(this._soulIcon);
            PositionUtils.setPos(this._soulIcon, "asset.newpetsbag.soulPos");
            this.createSkillList();
            if (((!(SavePointManager.Instance.savePoints[72])) && (TaskManager.instance.isAchieved(TaskManager.instance.getQuestByID(591)))))
            {
                this._learnSkillTips = (ClassUtils.CreatInstance("asset.trainer.clickToLearnSkill") as MovieClip);
                _local_2 = ComponentFactory.Instance.creatCustomObject("trainer.learnPetSkill");
                this._learnSkillTips.x = _local_2.x;
                this._learnSkillTips.y = _local_2.y;
                _container.addChild(this._learnSkillTips);
            };
            _local_1 = ComponentFactory.Instance.creat("petsBag.petSkillView.soulTipRect");
            this._soulTipArea = new Sprite();
            this._soulTipArea.graphics.beginFill(0xFF0000, 0);
            this._soulTipArea.graphics.drawRect(_local_1.x, _local_1.y, _local_1.width, _local_1.height);
            addToContent(this._soulTipArea);
            this._mouseTip = new OneLineTip();
            this._mouseTip.tipData = LanguageMgr.GetTranslation("petsBag.view.petSkillFrame.soulTipTxt");
            this._mouseTip.x = _local_1.x;
            this._mouseTip.y = (_local_1.y + _local_1.height);
            this._mouseTip.visible = false;
            addToContent(this._mouseTip);
        }

        private function initEvent():void
        {
            this._soulTipArea.addEventListener(MouseEvent.ROLL_OVER, this.__mouseOver);
            this._soulTipArea.addEventListener(MouseEvent.ROLL_OUT, this.__mouseOut);
        }

        private function removeEvent():void
        {
            this._soulTipArea.removeEventListener(MouseEvent.ROLL_OVER, this.__mouseOver);
            this._soulTipArea.removeEventListener(MouseEvent.ROLL_OUT, this.__mouseOut);
        }

        protected function __mouseOver(_arg_1:MouseEvent):void
        {
            this._mouseTip.visible = true;
        }

        protected function __mouseOut(_arg_1:MouseEvent):void
        {
            this._mouseTip.visible = false;
        }

        protected function createSkillList():void
        {
            var _local_1:PetSkillLevelUpItem;
            this._skillList = new Vector.<PetSkillLevelUpItem>();
            var _local_2:int = 1;
            while (_local_2 <= SKILL_COUNT)
            {
                _local_1 = ComponentFactory.Instance.creat(("petsBag.petSkillView.skillItem" + _local_2), [_local_2]);
                _local_1.addEventListener(PetSkillEvent.UPGRADE, this.__itemClick);
                addToContent(_local_1);
                this._skillList.push(_local_1);
                _local_2++;
            };
        }

        protected function __itemClick(_arg_1:PetSkillEvent):void
        {
            _arg_1.stopImmediatePropagation();
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._learnSkillTips)
            {
                this._learnSkillTips.parent.removeChild(this._learnSkillTips);
                this._learnSkillTips = null;
            };
            if ((!(SavePointManager.Instance.savePoints[72])))
            {
                SavePointManager.Instance.setSavePoint(72);
            };
            var _local_2:PetSkillTemplateInfo = _arg_1.data;
            if (_local_2)
            {
                SocketManager.Instance.out.sendPetSkillUp(_info.Place, _local_2.SkillID, _local_2.SkillPlace);
            };
        }

        override public function reset():void
        {
            var _local_1:PetSkillLevelUpItem;
            for each (_local_1 in this._skillList)
            {
                _local_1.reset();
            };
        }

        override public function set info(_arg_1:PetInfo):void
        {
            var _local_4:int;
            var _local_5:PetSkillItemInfo;
            _info = _arg_1;
            this._soulValueTxt.text = String(PlayerManager.Instance.Self.magicSoul);
            var _local_2:DictionaryData = _info.skills;
            var _local_3:int = 1;
            while (_local_3 <= SKILL_COUNT)
            {
                if (_local_2[_local_3])
                {
                    _local_4 = _local_2[_local_3];
                }
                else
                {
                    _local_4 = PetSkillManager.instance.getSkillID(_local_3, _info.KindID);
                };
                _local_5 = new PetSkillItemInfo();
                _local_5.skillID = _local_4;
                _local_5.petInfo = _info;
                this._skillList[(_local_3 - 1)].info = _local_5;
                _local_3++;
            };
        }

        override public function dispose():void
        {
            ObjectUtils.disposeObject(this._bg2);
            this._bg2 = null;
            ObjectUtils.disposeObject(this._soulValueTxt);
            this._soulValueTxt = null;
            ObjectUtils.disposeObject(this._soulIcon);
            this._soulIcon = null;
            while (this._skillList.length > 0)
            {
                this._skillList.shift().dispose();
            };
            ObjectUtils.disposeObject(this._soulTipArea);
            this._soulTipArea = null;
            ObjectUtils.disposeObject(this._mouseTip);
            this._mouseTip = null;
            this._skillList = null;
            if (this._titleBmp)
            {
                ObjectUtils.disposeObject(this._titleBmp);
            };
            this._titleBmp = null;
            super.dispose();
        }


    }
}//package petsBag.view

