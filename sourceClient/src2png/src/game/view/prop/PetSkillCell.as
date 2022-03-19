// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.prop.PetSkillCell

package game.view.prop
{
    import pet.date.PetSkillInfo;
    import flash.display.Sprite;
    import ddt.display.BitmapLoaderProxy;
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import com.pickgliss.ui.ShowTipManager;
    import ddt.manager.PathManager;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.view.tips.ToolPropInfo;
    import com.pickgliss.utils.ClassUtils;
    import com.pickgliss.utils.ObjectUtils;

    public class PetSkillCell extends PropCell 
    {

        private var _skill:PetSkillInfo;
        private var _turnNum:int = 0;
        private var _tempPic:Sprite;
        private var _skillPic:BitmapLoaderProxy;
        private var _lockBg:Bitmap;
        private var _normHeight:Number;
        private var _normWidth:Number;
        private var _skillPicWidth:Number = 33;
        private var _skillPicHeight:Number = 33;
        private var _shineMC:MovieClip;

        public function PetSkillCell(_arg_1:String=null, _arg_2:int=-1, _arg_3:Boolean=false, _arg_4:Number=0, _arg_5:Number=0)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.setGrayFilter();
            this._normWidth = _arg_4;
            this._normHeight = _arg_5;
        }

        override public function get tipStyle():String
        {
            return ("ddt.view.tips.PetSkillCellTip");
        }

        override public function get tipData():Object
        {
            return (this._skill);
        }

        private function creatTempSprite():void
        {
            this._tempPic = new Sprite();
            this._tempPic.graphics.beginFill(0xFFFFFF, 0.1);
            this._tempPic.graphics.drawRect(0, 0, this._skillPicWidth, this._skillPicHeight);
            this._tempPic.graphics.endFill();
            addChild(this._tempPic);
        }

        public function creteSkillCell(_arg_1:PetSkillInfo, _arg_2:Boolean=false):void
        {
            ShowTipManager.Instance.removeTip(this);
            this._skill = _arg_1;
            if (((this._skill) && (this._skill.ID > 0)))
            {
                this.creatTempSprite();
                this._skillPic = new BitmapLoaderProxy(PathManager.solveSkillPicUrl(this._skill.Pic), new Rectangle(0, 0, this._skillPicWidth, this._skillPicHeight));
                addChild(this._skillPic);
                ShowTipManager.Instance.addTip(this);
                this._turnNum = this._skill.ColdDown;
                buttonMode = true;
            }
            else
            {
                _fore = _bitmapMgr.creatBitmapShape("asset.game.petSkillBarCellBg", null, false, true);
                addChild(_fore);
                buttonMode = false;
                _tipInfo = null;
            };
            if (_arg_2)
            {
                this.drawLockBg();
            };
            this.shortcutKeyConfigUI();
            this.positionAdjust();
        }

        private function positionAdjust():void
        {
            if (this._skillPic)
            {
                if (this._normWidth > 0)
                {
                    this._skillPic.x = ((this._normWidth - this._skillPicWidth) / 2);
                };
                if (this._normHeight > 0)
                {
                    this._skillPic.y = ((this._normHeight - this._skillPicHeight) / 2);
                };
            };
            if (((_shortcutKeyShape) && (this._skillPic)))
            {
                _shortcutKeyShape.x = this._skillPic.x;
                _shortcutKeyShape.y = this._skillPic.y;
            };
            if (_fore)
            {
                if (this._normWidth > 0)
                {
                    _fore.x = ((this._normWidth - this._skillPicWidth) / 2);
                };
                if (this._normHeight > 0)
                {
                    _fore.y = ((this._normHeight - this._skillPicHeight) / 2);
                };
            };
        }

        private function drawLockBg():void
        {
            if (((!(this._skill)) && (!(this._lockBg))))
            {
                this._lockBg = ComponentFactory.Instance.creatBitmap("asset.game.petSkillLockBg");
                addChild(this._lockBg);
            };
        }

        override protected function configUI():void
        {
            _tipInfo = new ToolPropInfo();
            _tipInfo.showThew = true;
        }

        private function shortcutKeyConfigUI():void
        {
            this._shineMC = ClassUtils.CreatInstance("asset.bossplayer.flashMC");
            this._shineMC.visible = false;
            this._shineMC.stop();
            addChild(this._shineMC);
            if (((!(_shortcutKey == null)) && (_shortcutKeyShape == null)))
            {
                if ((((this._skill) && (this._skill.isActiveSkill)) || (!(this._skill))))
                {
                    _shortcutKeyShape = ComponentFactory.Instance.creatBitmap(("asset.game.prop.ShortcutKey" + _shortcutKey));
                    Bitmap(_shortcutKeyShape).smoothing = true;
                    _shortcutKeyShape.y = -2;
                    addChild(_shortcutKeyShape);
                    drawLayer();
                }
                else
                {
                    _shortcutKey = null;
                };
            };
        }

        public function shine():void
        {
            this._shineMC.visible = true;
            this._shineMC.play();
        }

        public function stopShine():void
        {
            this._shineMC.visible = false;
            this._shineMC.stop();
        }

        public function get skillInfo():PetSkillInfo
        {
            return (this._skill);
        }

        public function get isEnabled():Boolean
        {
            if (((this._skill) && (this._skill.isActiveSkill)))
            {
                return (true);
            };
            return (false);
        }

        override public function dispose():void
        {
            super.dispose();
            ShowTipManager.Instance.removeTip(this);
            if (this._lockBg)
            {
                ObjectUtils.disposeObject(this._lockBg);
            };
            this._lockBg = null;
            ObjectUtils.disposeObject(this._skillPic);
            this._skillPic = null;
            ObjectUtils.disposeObject(this._tempPic);
            this._tempPic = null;
            this._skill = null;
        }

        public function get turnNum():int
        {
            return (this._turnNum);
        }

        public function set turnNum(_arg_1:int):void
        {
            this._turnNum = _arg_1;
        }


    }
}//package game.view.prop

