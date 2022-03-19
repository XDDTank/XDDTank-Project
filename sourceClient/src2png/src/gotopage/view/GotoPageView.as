// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//gotopage.view.GotoPageView

package gotopage.view
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SavePointManager;
    import ddt.manager.SoundManager;
    import room.RoomManager;
    import ddt.manager.StateManager;
    import ddt.states.StateType;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import update.UpdateDescFrame;
    import tofflist.TofflistManager;
    import tofflist.TofflistController;
    import ddt.data.UIModuleTypes;
    import com.pickgliss.ui.ComponentSetting;
    import setting.controll.SettingController;
    import cityWide.CityWideManager;
    import civil.CivilController;
    import militaryrank.MilitaryRankManager;
    import __AS3__.vec.*;

    public class GotoPageView extends BaseAlerFrame 
    {

        private var _btnList:Vector.<SimpleBitmapButton>;
        private var _btnListContainer:SimpleTileList;
        private var _bg:Scale9CornerImage;
        private var _setBtn:SimpleBitmapButton;
        private var _friendBtn:SimpleBitmapButton;
        private var _tofflistBtn:SimpleBitmapButton;
        private var _updateBtn:SimpleBitmapButton;
        private var _PVPBtn:SimpleBitmapButton;
        private var _light:Bitmap;
        private var _vline:MutipleImage;
        private var _hline:MutipleImage;
        private var _event:MouseEvent;

        public function GotoPageView()
        {
            this.initView();
        }

        override public function dispose():void
        {
            GotoPageController.Instance.isShow = false;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._setBtn)
            {
                ObjectUtils.disposeObject(this._setBtn);
            };
            this._setBtn = null;
            if (this._friendBtn)
            {
                ObjectUtils.disposeObject(this._friendBtn);
            };
            this._friendBtn = null;
            if (this._tofflistBtn)
            {
                ObjectUtils.disposeObject(this._tofflistBtn);
            };
            this._tofflistBtn = null;
            if (this._updateBtn)
            {
                ObjectUtils.disposeObject(this._updateBtn);
            };
            this._updateBtn = null;
            if (this._PVPBtn)
            {
                ObjectUtils.disposeObject(this._PVPBtn);
            };
            this._PVPBtn = null;
            if (this._vline)
            {
                ObjectUtils.disposeObject(this._vline);
            };
            this._vline = null;
            if (this._hline)
            {
                ObjectUtils.disposeObject(this._hline);
            };
            this._hline = null;
            if (this._btnList)
            {
                this.clearBtn();
            };
            ObjectUtils.disposeObject(this._btnListContainer);
            this._btnList = null;
            if (parent)
            {
                parent.removeChild(this);
            };
            super.dispose();
        }

        private function initView():void
        {
            info = new AlertInfo(LanguageMgr.GetTranslation("tank.view.ChannelList.FastMenu.titleText"));
            _info.showSubmit = false;
            _info.showCancel = false;
            _info.moveEnable = false;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("gotopage.GotoPageView.bg");
            addToContent(this._bg);
            this._setBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.setBtn");
            addToContent(this._setBtn);
            this._friendBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.friendBtn");
            addToContent(this._friendBtn);
            this._friendBtn.mouseEnabled = false;
            this._friendBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if (SavePointManager.Instance.savePoints[13])
            {
                this._friendBtn.mouseEnabled = true;
                this._friendBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            };
            this._tofflistBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.famehallBtn");
            addToContent(this._tofflistBtn);
            this._tofflistBtn.mouseEnabled = false;
            this._tofflistBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if (SavePointManager.Instance.savePoints[27])
            {
                this._tofflistBtn.mouseEnabled = true;
                this._tofflistBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            };
            this._updateBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.updateBtn");
            addToContent(this._updateBtn);
            this._PVPBtn = ComponentFactory.Instance.creatComponentByStylename("gotopage.PVPBtn");
            addToContent(this._PVPBtn);
            this._PVPBtn.mouseEnabled = false;
            this._PVPBtn.filters = ComponentFactory.Instance.creatFilters("grayFilter");
            if (SavePointManager.Instance.savePoints[27])
            {
                this._PVPBtn.mouseEnabled = true;
                this._PVPBtn.filters = ComponentFactory.Instance.creatFilters("lightFilter");
            };
            this._vline = ComponentFactory.Instance.creatComponentByStylename("gotopage.vline");
            addToContent(this._vline);
            this._hline = ComponentFactory.Instance.creatComponentByStylename("gotopage.hline");
            addToContent(this._hline);
            this._btnList = new Vector.<SimpleBitmapButton>();
            this._btnList.push(this._PVPBtn);
            this._btnList.push(this._tofflistBtn);
            this._btnList.push(this._friendBtn);
            this._btnList.push(this._setBtn);
            this._btnList.push(this._updateBtn);
            this.creatBtn();
        }

        private function creatBtn():void
        {
            var _local_1:int;
            while (_local_1 < this._btnList.length)
            {
                this._btnList[_local_1].addEventListener(MouseEvent.MOUSE_OVER, this.__overHandle);
                this._btnList[_local_1].addEventListener(MouseEvent.MOUSE_OUT, this.__outHandle);
                this._btnList[_local_1].addEventListener(MouseEvent.CLICK, this.__clickHandle);
                _local_1++;
            };
        }

        private function clearBtn():void
        {
            var _local_1:int;
            while (_local_1 < this._btnList.length)
            {
                if (this._btnList[_local_1])
                {
                    this._btnList[_local_1].removeEventListener(MouseEvent.MOUSE_OVER, this.__overHandle);
                    this._btnList[_local_1].removeEventListener(MouseEvent.MOUSE_OUT, this.__outHandle);
                    this._btnList[_local_1].removeEventListener(MouseEvent.CLICK, this.__clickHandle);
                    ObjectUtils.disposeObject(this._btnList[_local_1]);
                };
                this._btnList[_local_1] = null;
                _local_1++;
            };
        }

        private function __overHandle(_arg_1:MouseEvent):void
        {
        }

        private function __outHandle(_arg_1:MouseEvent):void
        {
        }

        private function __clickHandle(_arg_1:MouseEvent):void
        {
            _arg_1.stopImmediatePropagation();
            var _local_2:int = this._btnList.indexOf((_arg_1.currentTarget as SimpleBitmapButton));
            this._event = _arg_1;
            SoundManager.instance.play("047");
            if ((((!(_arg_1.currentTarget == this._setBtn)) && (!(RoomManager.Instance.current == null))) && (!(RoomManager.Instance.current.selfRoomPlayer == null))))
            {
                if (((((StateManager.currentStateType == StateType.MISSION_ROOM) || (RoomManager.Instance.current.isOpenBoss)) && (!(RoomManager.Instance.current.selfRoomPlayer.isViewer))) && (((!(_local_2 == 0)) && (!(_local_2 == 1))) && (!(_local_2 == 4)))))
                {
                    this.showAlert();
                    return;
                };
            };
            this.skipView(_arg_1);
        }

        private function showAlert():void
        {
            var _local_1:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"), LanguageMgr.GetTranslation("tank.missionsettle.dungeon.leaveConfirm.contents"), "", LanguageMgr.GetTranslation("cancel"), true, true, false, LayerManager.BLCAK_BLOCKGOUND);
            _local_1.moveEnable = false;
            _local_1.addEventListener(FrameEvent.RESPONSE, this.__onResponse);
        }

        private function __onResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BaseAlerFrame = (_arg_1.target as BaseAlerFrame);
            _local_2.removeEventListener(FrameEvent.RESPONSE, this.__onResponse);
            _local_2.dispose();
            _local_2 = null;
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                this.skipView(this._event);
            }
            else
            {
                this.dispose();
                dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
            };
        }

        private function skipView(_arg_1:MouseEvent):void
        {
            var _local_3:UpdateDescFrame;
            var _local_2:int = this._btnList.indexOf((_arg_1.currentTarget as SimpleBitmapButton));
            switch (_local_2)
            {
                case 1:
                    TofflistManager.Instance.showToffilist(TofflistController.Instance.setup, UIModuleTypes.TOFFLIST);
                    ComponentSetting.SEND_USELOG_ID(8);
                    break;
                case 3:
                    SettingController.Instance.switchVisible();
                    break;
                case 2:
                    CityWideManager.Instance.showCityWide(CivilController.Instance.setup, UIModuleTypes.DDTCIVIL);
                    ComponentSetting.SEND_USELOG_ID(10);
                    break;
                case 0:
                    MilitaryRankManager.Instance.show();
                    break;
                case 4:
                    _local_3 = ComponentFactory.Instance.creatComponentByStylename("ddt.update.descFrame");
                    _local_3.show();
                    break;
            };
            dispatchEvent(new FrameEvent(FrameEvent.CLOSE_CLICK));
        }

        private function toDungeon():void
        {
            StateManager.setState(StateType.SINGLEDUNGEON);
        }


    }
}//package gotopage.view

