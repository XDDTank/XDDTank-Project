// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//update.UpdateDescFrame

package update
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import update.data.PopSysNoticeBaseInfo;
    import __AS3__.vec.Vector;
    import update.data.PopSysNoticeContentInfo;
    import com.pickgliss.ui.vo.AlertInfo;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.DisplayObject;
    import flash.display.Bitmap;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.SharedManager;
    import ddt.utils.PositionUtils;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class UpdateDescFrame extends BaseAlerFrame 
    {

        private var _titleInfo:PopSysNoticeBaseInfo;
        private var _contentInfo:Vector.<PopSysNoticeContentInfo>;
        private var _alertInfo:AlertInfo;
        private var _itemPanel:ScrollPanel;
        private var _itemVBox:VBox;
        private var _bigTitle:FilterFrameText;
        private var _updateTimeTxt:FilterFrameText;
        private var _bg:DisplayObject;
        private var _titleBG:Bitmap;

        public function UpdateDescFrame()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            var _local_2:PopSysNoticeContentInfo;
            var _local_3:uint;
            var _local_4:VBox;
            var _local_5:FilterFrameText;
            var _local_6:FilterFrameText;
            this._alertInfo = new AlertInfo();
            this._alertInfo.title = LanguageMgr.GetTranslation("ddt.update.frame.title");
            this._alertInfo.moveEnable = false;
            this._alertInfo.showCancel = false;
            info = this._alertInfo;
            this._bg = ComponentFactory.Instance.creat("updateFrame.BG");
            addToContent(this._bg);
            this._titleBG = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
            addToContent(this._titleBG);
            this._titleInfo = UpdateController.Instance.lastNoticeBase;
            this._contentInfo = new Vector.<PopSysNoticeContentInfo>();
            var _local_1:Array = UpdateController.Instance.noticeContentList;
            if ((((this._titleInfo) && (_local_1)) && (_local_1.length > 0)))
            {
                _local_3 = 0;
                while (_local_3 < _local_1.length)
                {
                    if (_local_1[_local_3].ID == this._titleInfo.ID)
                    {
                        this._contentInfo.push(_local_1[_local_3]);
                    };
                    _local_3++;
                };
                this._contentInfo.sort(this.sortContentInfo);
            };
            this._bigTitle = ComponentFactory.Instance.creatComponentByStylename("updateFrame.bigTitle.txt");
            this._updateTimeTxt = ComponentFactory.Instance.creatComponentByStylename("updateFrame.content.txt");
            if (this._titleInfo)
            {
                this._bigTitle.text = this._titleInfo.Title;
                SharedManager.Instance.showUpdateFrameDate = this._titleInfo.BeginTime;
                this._updateTimeTxt.text = ((LanguageMgr.GetTranslation("ddt.update.frame.updateTime") + ":") + this._titleInfo.BeginTime.split(" ")[0]);
            };
            PositionUtils.setPos(this._updateTimeTxt, "update.frame.updateTime.pos");
            addToContent(this._updateTimeTxt);
            addToContent(this._bigTitle);
            this._itemPanel = ComponentFactory.Instance.creatComponentByStylename("updateFrame.listPanel");
            this._itemVBox = ComponentFactory.Instance.creatComponentByStylename("updateFrame.listVbox");
            this._itemPanel.setView(this._itemVBox);
            this._itemVBox.beginChanges();
            for each (_local_2 in this._contentInfo)
            {
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("updateFrame.smallInfoVbox");
                _local_4.beginChanges();
                _local_5 = ComponentFactory.Instance.creatComponentByStylename("updateFrame.smallTitle.txt");
                _local_6 = ComponentFactory.Instance.creatComponentByStylename("updateFrame.content.txt");
                _local_5.text = _local_2.LineTitle;
                _local_6.text = _local_2.Content;
                _local_4.addChild(_local_5);
                _local_4.addChild(_local_6);
                _local_4.commitChanges();
                this._itemVBox.addChild(_local_4);
            };
            this._itemVBox.commitChanges();
            this._itemPanel.invalidateViewport();
            addToContent(this._itemPanel);
        }

        private function sortContentInfo(_arg_1:PopSysNoticeContentInfo, _arg_2:PopSysNoticeContentInfo):int
        {
            if (_arg_1.Order >= _arg_2.Order)
            {
                return (1);
            };
            return (-1);
        }

        private function addEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function removeEvent():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            switch (_arg_1.responseCode)
            {
                case FrameEvent.CANCEL_CLICK:
                case FrameEvent.CLOSE_CLICK:
                case FrameEvent.ESC_CLICK:
                    this.dispose();
                    return;
                case FrameEvent.ENTER_CLICK:
                case FrameEvent.SUBMIT_CLICK:
                    this.dispose();
                    return;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            SharedManager.Instance.hasShowUpdateFrame = true;
        }

        override public function dispose():void
        {
            super.dispose();
            this.removeEvent();
            this._titleInfo = null;
            this._contentInfo = null;
            ObjectUtils.disposeObject(this._bg);
            this._bg = null;
            ObjectUtils.disposeObject(this._alertInfo);
            this._alertInfo = null;
            ObjectUtils.disposeObject(this._itemVBox);
            this._itemVBox = null;
            ObjectUtils.disposeObject(this._itemPanel);
            this._itemPanel = null;
            ObjectUtils.disposeObject(this._bigTitle);
            this._bigTitle = null;
            ObjectUtils.disposeObject(this._updateTimeTxt);
            this._updateTimeTxt = null;
            ObjectUtils.disposeObject(this._titleBG);
            this._titleBG = null;
        }


    }
}//package update

