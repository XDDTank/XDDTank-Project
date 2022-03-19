// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//totem.view.TotemInfoView

package totem.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import ddt.data.player.PlayerInfo;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.text.FilterFrameText;
    import bagAndInfo.bag.PlayerPersonView;
    import com.pickgliss.utils.ClassUtils;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import totem.TotemManager;
    import flash.events.MouseEvent;
    import com.pickgliss.ui.LayerManager;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import totem.data.TotemDataVo;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class TotemInfoView extends Sprite implements Disposeable 
    {

        private var _playerBgMc:MovieClip;
        private var _info:PlayerInfo;
        private var _pageTitle:ScaleFrameImage;
        private var _levelTxtList:Vector.<FilterFrameText>;
        private var _txtArray:Array;
        private var _currentLevel:int;
        private var _currentPage:int;
        private var _tipView:TotemLeftWindowChapterTipView;
        private var _personView:PlayerPersonView;

        public function TotemInfoView(_arg_1:PlayerInfo)
        {
            this._info = _arg_1;
            this.initView();
            this.initPropTxt();
            this.initEvent();
            this.createChapterTip();
            this.createPersonView();
        }

        private function initView():void
        {
            var _local_1:int;
            this._playerBgMc = ClassUtils.CreatInstance("totem.viewInfoMC");
            PositionUtils.setPos(this._playerBgMc, "totem.playerInfoMcPos");
            this._pageTitle = ComponentFactory.Instance.creatComponentByStylename("totem.viewInfo.Title");
            addChild(this._playerBgMc);
            addChild(this._pageTitle);
            this._currentLevel = TotemManager.instance.getCurrentLv(TotemManager.instance.getTotemPointLevel(this._info.totemId));
            this._currentPage = TotemManager.instance.getCurInfoById(this._info.totemId).Page;
            this._currentPage = ((this._currentPage == 0) ? 1 : this._currentPage);
            this._pageTitle.setFrame(this._currentPage);
            if (this._info.totemId < 10007)
            {
                _local_1 = (((this._info.totemId - 10000) % 7) + 1);
            }
            else
            {
                _local_1 = 8;
            };
            this._playerBgMc.gotoAndStop(_local_1);
        }

        private function initEvent():void
        {
            this._pageTitle.addEventListener(MouseEvent.MOUSE_OVER, this._showTip);
            this._pageTitle.addEventListener(MouseEvent.MOUSE_OUT, this._hideTip);
        }

        private function createChapterTip():void
        {
            this._tipView = new TotemLeftWindowChapterTipView();
            this._tipView.visible = false;
            LayerManager.Instance.addToLayer(this._tipView, LayerManager.GAME_TOP_LAYER);
        }

        private function createPersonView():void
        {
            this._personView = ComponentFactory.Instance.creat("bagAndInfo.PlayerPersonView");
            PositionUtils.setPos(this._personView, "totemInfoView.PlayerPersonView.pos");
            this._personView.info = this._info;
            this._personView.setHpVisble(false);
            addChild(this._personView);
        }

        private function _showTip(_arg_1:MouseEvent):void
        {
            var _local_2:Point;
            _local_2 = this.localToGlobal(new Point((this.mouseX + 5), this.mouseY));
            this._tipView.x = (_local_2.x + 20);
            this._tipView.y = _local_2.y;
            this._tipView.show(this._currentPage);
            this._tipView.visible = true;
        }

        private function _hideTip(_arg_1:MouseEvent):void
        {
            this._tipView.visible = false;
        }

        private function initPropTxt():void
        {
            var _local_5:FilterFrameText;
            var _local_1:String = LanguageMgr.GetTranslation("ddt.totem.sevenProperty");
            this._txtArray = _local_1.split(",");
            this._levelTxtList = new Vector.<FilterFrameText>();
            var _local_2:TotemDataVo = TotemManager.instance.getCurInfoById(this._info.totemId);
            _local_2.ID = (_local_2.ID + 1);
            var _local_3:Array = TotemManager.instance.getCurrentLvList(TotemManager.instance.getTotemPointLevel(this._info.totemId), this._currentPage, _local_2);
            var _local_4:int = 1;
            while (_local_4 <= 7)
            {
                _local_5 = ComponentFactory.Instance.creatComponentByStylename(("totem.totemWindow.propertyName" + _local_4));
                this._levelTxtList.push(_local_5);
                PositionUtils.setPos(_local_5, ("totem.viewInfoPropTxtPos" + _local_4));
                _local_5.text = LanguageMgr.GetTranslation("ddt.totem.totemWindow.propertyLvTxt", _local_3[(_local_4 - 1)], ((this._txtArray[(_local_4 - 1)] + "+") + TotemManager.instance.getAddValue(_local_4, TotemManager.instance.getAddInfo(TotemManager.instance.getTotemPointLevel(this._info.totemId)))));
                addChild(_local_5);
                _local_4++;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._pageTitle.removeEventListener(MouseEvent.MOUSE_OVER, this._showTip);
            this._pageTitle.removeEventListener(MouseEvent.MOUSE_OUT, this._hideTip);
            this._playerBgMc = null;
            this._pageTitle = null;
            this._info = null;
            this._levelTxtList = null;
            ObjectUtils.disposeObject(this._tipView);
            this._tipView = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package totem.view

