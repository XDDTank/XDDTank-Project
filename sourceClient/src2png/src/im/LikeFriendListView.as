// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//im.LikeFriendListView

package im
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.controls.ListPanel;
    import ddt.data.player.LikeFriendInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.events.ListItemEvent;
    import ddt.utils.RequestVairableCreater;
    import flash.net.URLVariables;
    import ddt.manager.PlayerManager;
    import com.pickgliss.loader.LoadResourceManager;
    import ddt.manager.PathManager;
    import com.pickgliss.loader.BaseLoader;
    import ddt.manager.LanguageMgr;
    import ddt.data.analyze.LikeFriendAnalyzer;
    import com.pickgliss.loader.LoaderEvent;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.geom.IntPoint;

    public class LikeFriendListView extends Sprite implements Disposeable 
    {

        private var _list:ListPanel;
        private var _likeFriendList:Array;
        private var _currentItem:LikeFriendInfo;
        private var _pos:int;

        public function LikeFriendListView()
        {
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            this._list = ComponentFactory.Instance.creatComponentByStylename("IM.LikeFriendListPanel");
            this._list.vScrollProxy = ScrollPanel.AUTO;
            addChild(this._list);
            this._list.list.updateListView();
            if (IMController.Instance.likeFriendList != null)
            {
                this._likeFriendList = IMController.Instance.likeFriendList;
                this.__updateList();
            };
            this.creatItemTempleteLoader();
        }

        private function initEvents():void
        {
            this._list.list.addEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
        }

        private function removeEvents():void
        {
            this._list.list.removeEventListener(ListItemEvent.LIST_ITEM_CLICK, this.__itemClick);
        }

        private function creatItemTempleteLoader():BaseLoader
        {
            var _local_1:URLVariables = RequestVairableCreater.creatWidthKey(true);
            _local_1["selfid"] = PlayerManager.Instance.Self.ID;
            var _local_2:BaseLoader = LoadResourceManager.instance.createLoader(PathManager.solveRequestPath("SameCityIMLoad.ashx"), BaseLoader.REQUEST_LOADER, _local_1);
            _local_2.loadErrorMessage = LanguageMgr.GetTranslation("ddt.loader.LoadingLikeFriendTemplateFailure");
            _local_2.analyzer = new LikeFriendAnalyzer(this.__loadComplete);
            _local_2.addEventListener(LoaderEvent.LOAD_ERROR, this.__onLoadError);
            LoadResourceManager.instance.startLoad(_local_2);
            return (_local_2);
        }

        private function __onLoadError(_arg_1:LoaderEvent):void
        {
            var _local_2:String = _arg_1.loader.loadErrorMessage;
            if (_arg_1.loader.analyzer)
            {
                if (_arg_1.loader.analyzer.message != null)
                {
                    _local_2 = ((_arg_1.loader.loadErrorMessage + "\n") + _arg_1.loader.analyzer.message);
                };
            };
            var _local_3:BaseAlerFrame = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("alert"), _local_2, LanguageMgr.GetTranslation("tank.room.RoomIIView2.affirm"));
            _local_3.addEventListener(FrameEvent.RESPONSE, this.__onAlertResponse);
        }

        private function __onAlertResponse(_arg_1:FrameEvent):void
        {
            ObjectUtils.disposeObject(_arg_1.currentTarget);
        }

        private function __loadComplete(_arg_1:LikeFriendAnalyzer):void
        {
            this._likeFriendList = (IMController.Instance.likeFriendList = _arg_1.likeFriendList);
            this.__updateList();
        }

        private function __itemClick(_arg_1:ListItemEvent):void
        {
            if ((!(this._currentItem)))
            {
                this._currentItem = (_arg_1.cellValue as LikeFriendInfo);
                this._currentItem.isSelected = true;
            }
            else
            {
                if (this._currentItem != (_arg_1.cellValue as LikeFriendInfo))
                {
                    this._currentItem.isSelected = false;
                    this._currentItem = (_arg_1.cellValue as LikeFriendInfo);
                    this._currentItem.isSelected = true;
                };
            };
            this._list.list.updateListView();
        }

        private function __updateList():void
        {
            if (this._list == null)
            {
                return;
            };
            this._pos = this._list.list.viewPosition.y;
            this.update();
            var _local_1:IntPoint = new IntPoint(0, this._pos);
            this._list.list.viewPosition = _local_1;
        }

        private function update():void
        {
            var _local_4:LikeFriendInfo;
            var _local_1:Array = [];
            var _local_2:Array = [];
            var _local_3:int;
            while (_local_3 < this._likeFriendList.length)
            {
                _local_4 = this._likeFriendList[_local_3];
                if (_local_4.IsVIP)
                {
                    _local_1.push(_local_4);
                }
                else
                {
                    _local_2.push(_local_4);
                };
                _local_3++;
            };
            _local_1 = _local_1.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            _local_2 = _local_2.sortOn("Grade", (Array.NUMERIC | Array.DESCENDING));
            this._likeFriendList = _local_1.concat(_local_2);
            this._list.vectorListModel.clear();
            this._list.vectorListModel.appendAll(this._likeFriendList);
            this._list.list.updateListView();
        }

        public function dispose():void
        {
            this.removeEvents();
            if (this._list)
            {
                ObjectUtils.disposeObject(this._list);
            };
            this._list = null;
            this._likeFriendList = null;
            ObjectUtils.disposeAllChildren(this);
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package im

