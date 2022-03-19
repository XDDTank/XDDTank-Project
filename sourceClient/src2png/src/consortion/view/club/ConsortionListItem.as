// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.club.ConsortionListItem

package consortion.view.club
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import ddt.data.ConsortiaInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.image.ScaleLeftRightImage;
    import consortion.view.selfConsortia.Badge;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.utils.PositionUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import consortion.ConsortionModelControl;
    import __AS3__.vec.Vector;
    import ddt.manager.PlayerManager;
    import ddt.manager.MessageTipManager;
    import ddt.manager.SocketManager;
    import consortion.view.selfConsortia.ConsortionInfoViewFrame;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class ConsortionListItem extends Sprite implements Disposeable 
    {

        private var _itemBG:ScaleFrameImage;
        private var _index:int;
        private var _info:ConsortiaInfo;
        private var _selected:Boolean;
        private var _consortionName:FilterFrameText;
        private var _chairMan:FilterFrameText;
        private var _count:FilterFrameText;
        private var _level:FilterFrameText;
        private var _exploit:FilterFrameText;
        private var _light:ScaleLeftRightImage;
        private var _badge:Badge;
        private var _check:TextButton;
        private var _agree:TextButton;
        private var _refuse:TextButton;
        private var _readlyApplyTxt:FilterFrameText;
        private var _id:int;

        public function ConsortionListItem(_arg_1:int)
        {
            this._index = _arg_1;
            this.init();
            this.initEvent();
        }

        private function init():void
        {
            this._badge = new Badge();
            this._itemBG = ComponentFactory.Instance.creatComponentByStylename("consortionClub.MemberListItem");
            if (((this._index % 2) == 0))
            {
                this._itemBG.setFrame(2);
            }
            else
            {
                this._itemBG.setFrame(1);
            };
            this._consortionName = ComponentFactory.Instance.creatComponentByStylename("club.consortionName");
            this._chairMan = ComponentFactory.Instance.creatComponentByStylename("club.chairMan");
            this._count = ComponentFactory.Instance.creatComponentByStylename("club.count");
            this._level = ComponentFactory.Instance.creatComponentByStylename("club.level");
            this._exploit = ComponentFactory.Instance.creatComponentByStylename("club.exploit");
            this._light = ComponentFactory.Instance.creatComponentByStylename("consortion.club.listItemlight");
            this._light.visible = false;
            this._check = ComponentFactory.Instance.creatComponentByStylename("consortion.clubItem.check");
            this._check.text = LanguageMgr.GetTranslation("tank.room.RoomIIPlayerItem.view");
            this._agree = ComponentFactory.Instance.creatComponentByStylename("consortion.clubItem.agree");
            this._agree.text = LanguageMgr.GetTranslation("ddt.consortion.club.cancelApplyText");
            this._agree.visible = false;
            this._refuse = ComponentFactory.Instance.creatComponentByStylename("consortion.clubItem.refuse");
            this._refuse.text = LanguageMgr.GetTranslation("ddt.consortion.club.applyText");
            this._readlyApplyTxt = ComponentFactory.Instance.creatComponentByStylename("consortion.readlyApplyTxt");
            this._readlyApplyTxt.text = LanguageMgr.GetTranslation("ddt.consortion.club.applyingText");
            this._readlyApplyTxt.visible = false;
            addChild(this._itemBG);
            addChild(this._light);
            addChild(this._badge);
            addChild(this._consortionName);
            addChild(this._chairMan);
            addChild(this._count);
            addChild(this._level);
            addChild(this._exploit);
            addChild(this._readlyApplyTxt);
            PositionUtils.setPos(this._badge, "consortionClubItem.badge.pos");
        }

        private function initEvent():void
        {
            this._check.addEventListener(MouseEvent.CLICK, this.__check);
            this._refuse.addEventListener(MouseEvent.CLICK, this.__refuse);
            this._agree.addEventListener(MouseEvent.CLICK, this.__agree);
        }

        private function removeEvent():void
        {
            this._check.removeEventListener(MouseEvent.CLICK, this.__check);
            this._refuse.removeEventListener(MouseEvent.CLICK, this.__refuse);
            this._agree.removeEventListener(MouseEvent.CLICK, this.__agree);
        }

        private function __refuse(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:Vector.<ConsortiaInfo> = ConsortionModelControl.Instance.model.readyApplyList;
            if (PlayerManager.Instance.Self.Grade < 13)
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.consortion.playerTip.notInvite"));
                return;
            };
            if ((!(this.info.OpenApply)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandler"));
                return;
            };
            if (((_local_2) && (_local_2.length >= 10)))
            {
                MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("tank.consortia.club.ConsortiaClubView.applyJoinClickHandlerFill"));
                return;
            };
            this.info.IsApply = true;
            SocketManager.Instance.out.sendConsortiaTryIn(this.info.ConsortiaID);
        }

        private function __agree(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            SocketManager.Instance.out.sendConsortiaTryinDelete(this.ID);
        }

        private function __check(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:ConsortiaInfo = ConsortionModelControl.Instance.model.getConosrionByID(this.info.ConsortiaID);
            var _local_3:ConsortionInfoViewFrame = ComponentFactory.Instance.creatComponentByStylename("consortionInfoFrame");
            _local_3.show();
            _local_3.info = _local_2;
        }

        public function set info(_arg_1:ConsortiaInfo):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (this._info == _arg_1)
            {
                return;
            };
            this._info = _arg_1;
            addChild(this._check);
            addChild(this._agree);
            addChild(this._refuse);
            this._badge.badgeID = this._info.BadgeID;
            this._badge.visible = (this._info.BadgeID > 0);
            this._consortionName.text = String(_arg_1.ConsortiaName);
            this._chairMan.text = String(_arg_1.ChairmanName);
            this._count.text = String(_arg_1.Count);
            this._level.text = String(_arg_1.Level);
            this._exploit.text = String(_arg_1.Number);
        }

        public function get info():ConsortiaInfo
        {
            return (this._info);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            this._light.visible = this._selected;
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set light(_arg_1:Boolean):void
        {
            if (this._selected)
            {
                return;
            };
            this._light.visible = _arg_1;
        }

        override public function get height():Number
        {
            if (this._itemBG == null)
            {
                return (0);
            };
            return (this._itemBG.y + this._itemBG.height);
        }

        public function getCellValue():*
        {
            return (this._info);
        }

        public function setCellValue(_arg_1:*):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function set isApply(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                this._light.visible = false;
                this._agree.visible = true;
                this._readlyApplyTxt.visible = true;
                this._refuse.visible = false;
                this._check.visible = false;
            }
            else
            {
                this._agree.visible = false;
                this._readlyApplyTxt.visible = false;
                this._refuse.visible = true;
                this._check.visible = true;
            };
        }

        public function set ID(_arg_1:int):void
        {
            this._id = _arg_1;
        }

        public function get ID():int
        {
            return (this._id);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._itemBG = null;
            this._consortionName = null;
            this._chairMan = null;
            this._count = null;
            this._level = null;
            this._exploit = null;
            this._light = null;
            this._agree = null;
            this._readlyApplyTxt = null;
            this._check = null;
            this._refuse = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package consortion.view.club

