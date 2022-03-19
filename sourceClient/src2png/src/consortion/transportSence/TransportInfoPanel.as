// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.transportSence.TransportInfoPanel

package consortion.transportSence
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import com.pickgliss.ui.controls.SelectedButton;
    import com.pickgliss.ui.controls.SelectedTextButton;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.SelectedButtonGroup;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import consortion.event.ConsortionEvent;
    import ddt.manager.SoundManager;
    import com.greensock.TweenLite;

    public class TransportInfoPanel extends Sprite implements Disposeable 
    {

        private var _bg:MutipleImage;
        private var _line:MutipleImage;
        private var _spreadBtn:SelectedButton;
        private var _myInfoBtn:SelectedTextButton;
        private var _allInfoBtn:SelectedTextButton;
        private var _listBox:VBox;
        private var _listPanel:ScrollPanel;
        private var _btnGroup:SelectedButtonGroup;
        private var _isOpen:Boolean;
        private var _isDisplayAll:Boolean;

        public function TransportInfoPanel()
        {
            this.initView();
            this.addEvent();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.BG");
            this._line = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.line");
            this._spreadBtn = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.spreadBtn");
            this._myInfoBtn = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.myInfoBtn");
            this._allInfoBtn = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.allInfoBtn");
            this._allInfoBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.info.all.text");
            this._myInfoBtn.text = LanguageMgr.GetTranslation("consortion.ConsortionTransport.info.myself.text");
            this._listBox = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.infoVBox");
            this._listPanel = ComponentFactory.Instance.creatComponentByStylename("TransportInfoPanel.infoScrollPanel");
            this._listPanel.setView(this._listBox);
            addChild(this._bg);
            addChild(this._spreadBtn);
            addChild(this._allInfoBtn);
            addChild(this._myInfoBtn);
            addChild(this._line);
            addChild(this._listPanel);
            this._btnGroup = new SelectedButtonGroup();
            this._btnGroup.addSelectItem(this._allInfoBtn);
            this._btnGroup.addSelectItem(this._myInfoBtn);
            this._btnGroup.selectIndex = 0;
            this._isOpen = true;
            this._isDisplayAll = true;
            this.showAllMessage();
        }

        private function addEvent():void
        {
            this._btnGroup.addEventListener(Event.CHANGE, this.__changeInfoState);
            this._spreadBtn.addEventListener(MouseEvent.CLICK, this.__closePanel);
            TransportManager.Instance.addEventListener(ConsortionEvent.TRANSPORT_ADD_MESSAGE, this.__addMessage);
        }

        private function removeEvent():void
        {
            this._btnGroup.removeEventListener(Event.CHANGE, this.__changeInfoState);
            this._spreadBtn.removeEventListener(MouseEvent.CLICK, this.__closePanel);
            TransportManager.Instance.removeEventListener(ConsortionEvent.TRANSPORT_ADD_MESSAGE, this.__addMessage);
        }

        private function showAllMessage():void
        {
            var _local_1:TransportInfoContent;
            this._listBox.disposeAllChildren();
            this._listBox.beginChanges();
            for each (_local_1 in TransportManager.Instance.messageList)
            {
                this._listBox.addChild(_local_1);
            };
            this._listBox.commitChanges();
            this._listPanel.invalidateViewport(true);
        }

        private function __changeInfoState(_arg_1:Event):void
        {
            var _local_2:TransportInfoContent;
            SoundManager.instance.play("008");
            this._listBox.disposeAllChildren();
            this._listBox.beginChanges();
            for each (_local_2 in TransportManager.Instance.messageList)
            {
                if (this._isDisplayAll)
                {
                    if (_local_2.isMyInfo)
                    {
                        this._listBox.addChild(_local_2);
                    };
                }
                else
                {
                    this._listBox.addChild(_local_2);
                };
            };
            if (this._isDisplayAll)
            {
                this._isDisplayAll = false;
            }
            else
            {
                this._isDisplayAll = true;
            };
            this._listBox.commitChanges();
            this._listPanel.invalidateViewport(true);
        }

        private function __closePanel(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            TweenLite.killTweensOf(this);
            if (this._isOpen)
            {
                TweenLite.to(this, 0.5, {"x":996});
                this._isOpen = false;
            }
            else
            {
                TweenLite.to(this, 0.5, {"x":769});
                this._isOpen = true;
            };
        }

        private function __addMessage(_arg_1:ConsortionEvent):void
        {
            var _local_2:TransportInfoContent = (_arg_1.data as TransportInfoContent);
            if (this._isDisplayAll)
            {
                this.addContentToList(_local_2);
            }
            else
            {
                if (_local_2.isMyInfo)
                {
                    this.addContentToList(_local_2);
                };
            };
        }

        private function addContentToList(_arg_1:TransportInfoContent):void
        {
            this._listBox.beginChanges();
            this._listBox.addChild(_arg_1);
            this._listBox.commitChanges();
            this._listPanel.invalidateViewport(true);
        }

        public function dispose():void
        {
            this.removeEvent();
            TweenLite.killTweensOf(this);
            while (this.numChildren > 0)
            {
                this.removeChildAt(0);
            };
            this._bg = null;
            this._line = null;
            this._spreadBtn = null;
            this._myInfoBtn = null;
            this._allInfoBtn = null;
            this._listPanel.dispose();
            this._listBox = null;
            this._listPanel = null;
            this._btnGroup.dispose();
            this._btnGroup = null;
        }


    }
}//package consortion.transportSence

