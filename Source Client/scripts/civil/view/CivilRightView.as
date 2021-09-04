package civil.view
{
   import civil.CivilController;
   import civil.CivilEvent;
   import civil.CivilModel;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.BaseButton;
   import com.pickgliss.ui.controls.SelectedButtonGroup;
   import com.pickgliss.ui.controls.SelectedTextButton;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.TextInput;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.image.ScaleBitmapImage;
   import com.pickgliss.ui.image.ScaleLeftRightImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.MessageTipManager;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import im.IMController;
   
   public class CivilRightView extends Sprite implements Disposeable
   {
       
      
      private var _listBg:MutipleImage;
      
      private var _btnBg:Scale9CornerImage;
      
      private var _formIineBig1:ScaleBitmapImage;
      
      private var _formIineBig2:ScaleBitmapImage;
      
      private var _preBtn:SimpleBitmapButton;
      
      private var _nextBtn:SimpleBitmapButton;
      
      private var _pagePreBg:ScaleLeftRightImage;
      
      private var _nameTitle:FilterFrameText;
      
      private var _levelTitle:FilterFrameText;
      
      private var _stateTitle:FilterFrameText;
      
      private var _pageTxt:FilterFrameText;
      
      private var _pageLastBg:ScaleLeftRightImage;
      
      private var _searchBG:Scale9CornerImage;
      
      private var _civilGenderGroup:SelectedButtonGroup;
      
      private var _maleBtn:SelectedTextButton;
      
      private var _femaleBtn:SelectedTextButton;
      
      private var _searchBtn:BaseButton;
      
      private var _registerBtn:BaseButton;
      
      private var _menberList:CivilPlayerInfoList;
      
      private var _controller:CivilController;
      
      private var _currentPage:int = 1;
      
      private var _model:CivilModel;
      
      private var _searchTxt:TextInput;
      
      private var _sex:Boolean;
      
      private var _loadMember:Boolean = false;
      
      private var _seachKey:String = "";
      
      private var _isBusy:Boolean;
      
      public function CivilRightView(param1:CivilController, param2:CivilModel)
      {
         this._model = param2;
         this._controller = param1;
         super();
         this.init();
         this.initButton();
         this.initEvnet();
         this._menberList.MemberList(this._model.civilPlayers);
         if(PlayerManager.Instance.Self.MarryInfoID <= 0 || !PlayerManager.Instance.Self.MarryInfoID)
         {
            SocketManager.Instance.out.sendRegisterInfo(PlayerManager.Instance.Self.ID,true,LanguageMgr.GetTranslation("civil.frame.CivilRegisterFrame.text"));
         }
      }
      
      public function dispose() : void
      {
         this.removeEvent();
         if(this._listBg)
         {
            this._listBg.dispose();
            this._listBg = null;
         }
         if(this._btnBg)
         {
            this._btnBg.dispose();
            this._btnBg = null;
         }
         if(this._formIineBig1)
         {
            this._formIineBig1.dispose();
         }
         if(this._formIineBig2)
         {
            this._formIineBig2.dispose();
         }
         if(this._preBtn)
         {
            this._preBtn.dispose();
            this._preBtn = null;
         }
         if(this._pagePreBg)
         {
            this._pagePreBg.dispose();
            this._pagePreBg = null;
         }
         if(this._pageLastBg)
         {
            this._pageLastBg.dispose();
            this._pageLastBg = null;
         }
         if(this._nextBtn)
         {
            this._nextBtn.dispose();
            this._nextBtn = null;
         }
         if(this._registerBtn)
         {
            this._registerBtn.dispose();
            this._registerBtn = null;
         }
         if(this._searchBtn)
         {
            this._searchBtn.dispose();
            this._searchBtn = null;
         }
         if(this._femaleBtn)
         {
            this._femaleBtn.dispose();
            this._femaleBtn = null;
         }
         if(this._maleBtn)
         {
            this._maleBtn.dispose();
            this._maleBtn = null;
         }
         if(this._civilGenderGroup)
         {
            this._civilGenderGroup.dispose();
            this._civilGenderGroup = null;
         }
         if(this._nameTitle)
         {
            ObjectUtils.disposeObject(this._nameTitle);
            this._nameTitle = null;
         }
         if(this._levelTitle)
         {
            ObjectUtils.disposeObject(this._levelTitle);
            this._levelTitle = null;
         }
         if(this._stateTitle)
         {
            ObjectUtils.disposeObject(this._stateTitle);
            this._stateTitle = null;
         }
         if(this._searchBG)
         {
            ObjectUtils.disposeObject(this._searchBG);
            this._searchBG = null;
         }
         if(this._searchTxt)
         {
            ObjectUtils.disposeObject(this._searchTxt);
            this._searchTxt = null;
         }
         if(this._pageTxt)
         {
            ObjectUtils.disposeObject(this._pageTxt);
            this._pageTxt = null;
         }
         if(this._menberList)
         {
            ObjectUtils.disposeObject(this._menberList);
            this._menberList = null;
         }
      }
      
      public function init() : void
      {
         this._listBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.rightListBgAsset");
         PositionUtils.setPos(this._listBg,"ddtcivil.rightListBg");
         addChild(this._listBg);
         this._btnBg = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.rightViewBtnBg");
         addChild(this._btnBg);
         this._formIineBig1 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.formIineBig1");
         addChild(this._formIineBig1);
         this._formIineBig2 = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.formIineBig2");
         addChild(this._formIineBig2);
         this._nameTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.nameTitle");
         this._nameTitle.text = LanguageMgr.GetTranslation("itemview.listname");
         addChild(this._nameTitle);
         this._levelTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.levelTitle");
         this._levelTitle.text = LanguageMgr.GetTranslation("itemview.listlevel");
         addChild(this._levelTitle);
         this._stateTitle = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.stateTitle");
         this._stateTitle.text = LanguageMgr.GetTranslation("itemview.liststate");
         addChild(this._stateTitle);
         this._searchBG = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.searchBg");
         addChild(this._searchBG);
         this._searchTxt = ComponentFactory.Instance.creat("ddtcivil.searchText");
         this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         addChild(this._searchTxt);
         this._menberList = ComponentFactory.Instance.creatCustomObject("civil.view.CivilPlayerInfoList");
         this._menberList.model = this._model;
         addChild(this._menberList);
         this._pagePreBg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.pagePreBg");
         addChild(this._pagePreBg);
         this._pageLastBg = ComponentFactory.Instance.creatComponentByStylename("ddtcivil.pageLastBg");
         addChild(this._pageLastBg);
         this._pageTxt = ComponentFactory.Instance.creat("ddtcivil.page");
         addChild(this._pageTxt);
      }
      
      private function initButton() : void
      {
         this._civilGenderGroup = new SelectedButtonGroup();
         this._searchBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.searchBtn");
         addChild(this._searchBtn);
         this._preBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.preBtn");
         addChild(this._preBtn);
         this._nextBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.nextBtn");
         addChild(this._nextBtn);
         this._registerBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.registerTxtBtn");
         addChild(this._registerBtn);
         this._maleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.maleButton");
         this._maleBtn.text = LanguageMgr.GetTranslation("civil.rightView.male");
         this._femaleBtn = ComponentFactory.Instance.creatComponentByStylename("asset.ddtcivil.femaleButton");
         this._femaleBtn.text = LanguageMgr.GetTranslation("civil.rightView.female");
         addChild(this._maleBtn);
         addChild(this._femaleBtn);
         this._civilGenderGroup.addSelectItem(this._maleBtn);
         this._civilGenderGroup.addSelectItem(this._femaleBtn);
      }
      
      private function initEvnet() : void
      {
         this._preBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._searchBtn.addEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._maleBtn.addEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._femaleBtn.addEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._registerBtn.addEventListener(MouseEvent.CLICK,this.__btnClick);
         this._searchTxt.addEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         this._menberList.addEventListener(CivilEvent.SELECTED_CHANGE,this.__memberSelectedChange);
         this._model.addEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__updateView);
         this._model.addEventListener(CivilEvent.REGISTER_CHANGE,this.__onRegisterChange);
      }
      
      private function removeEvent() : void
      {
         this._preBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._nextBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._searchBtn.removeEventListener(MouseEvent.CLICK,this.__leafBtnClick);
         this._maleBtn.removeEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._femaleBtn.removeEventListener(MouseEvent.CLICK,this.__sexBtnClick);
         this._searchTxt.removeEventListener(MouseEvent.CLICK,this.__searchTxtClick);
         this._menberList.removeEventListener(CivilEvent.SELECTED_CHANGE,this.__memberSelectedChange);
         this._registerBtn.removeEventListener(MouseEvent.CLICK,this.__btnClick);
         this._model.removeEventListener(CivilEvent.CIVIL_PLAYERINFO_ARRAY_CHANGE,this.__updateView);
         this._model.removeEventListener(CivilEvent.REGISTER_CHANGE,this.__onRegisterChange);
      }
      
      private function __onRegisterChange(param1:CivilEvent) : void
      {
      }
      
      private function __btnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._controller.Register();
      }
      
      private function __addBtnClick(param1:MouseEvent) : void
      {
         if(this._controller.currentcivilInfo && this._controller.currentcivilInfo.info)
         {
            SoundManager.instance.play("008");
            IMController.Instance.addFriend(this._controller.currentcivilInfo.info.NickName);
         }
      }
      
      private function __sexBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._currentPage = 1;
         if(param1.currentTarget == this._femaleBtn)
         {
            this._sex = false;
            if(this._sex == this._model.sex)
            {
               return;
            }
            this._model.sex = false;
         }
         else
         {
            this._sex = true;
            if(this._sex == this._model.sex)
            {
               return;
            }
            this._model.sex = true;
         }
         this._sex = this._model.sex;
         this._controller.loadCivilMemberList(this._currentPage,this._model.sex);
         if(this._searchTxt.text != LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
         else
         {
            this._searchTxt.text = LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt");
         }
         this._seachKey = "";
      }
      
      private function __leafBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._loadMember)
         {
            return;
         }
         if(this._isBusy)
         {
            return;
         }
         switch(param1.currentTarget)
         {
            case this._preBtn:
               this._currentPage = --this._currentPage;
               break;
            case this._nextBtn:
               this._currentPage = ++this._currentPage;
               break;
            case this._searchBtn:
               if(this._searchTxt.text == "" || this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
               {
                  MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("civil.view.CivilRightView.info"));
               }
               else
               {
                  this._seachKey = this._searchTxt.text;
                  this._currentPage = 1;
                  this._controller.loadCivilMemberList(this._currentPage,this._sex,this._seachKey);
                  this._loadMember = true;
               }
               return;
         }
         this._isBusy = true;
         this._controller.loadCivilMemberList(this._currentPage,this._sex,this._seachKey);
      }
      
      private function __searchTxtClick(param1:MouseEvent) : void
      {
         if(this._searchTxt.text == LanguageMgr.GetTranslation("academy.view.AcademyMemberListView.searchTxt"))
         {
            this._searchTxt.text = "";
         }
      }
      
      private function __memberSelectedChange(param1:CivilEvent) : void
      {
      }
      
      private function updateButton() : void
      {
         if(this._model.TotalPage == 1)
         {
            this.setButtonState(false,false);
         }
         else if(this._model.TotalPage == 0)
         {
            this.setButtonState(false,false);
         }
         else if(this._currentPage == 1)
         {
            this.setButtonState(false,true);
         }
         else if(this._currentPage == this._model.TotalPage && this._currentPage != 0)
         {
            this.setButtonState(true,false);
         }
         else
         {
            this.setButtonState(true,true);
         }
         if(!this._model.TotalPage)
         {
            this._pageTxt.text = String(1) + " / " + String(1);
         }
         else
         {
            this._pageTxt.text = String(this._currentPage) + " / " + String(this._model.TotalPage);
         }
         this.updateSex();
      }
      
      private function updateSex() : void
      {
         if(this._model.sex)
         {
            this._civilGenderGroup.selectIndex = 0;
         }
         else
         {
            this._civilGenderGroup.selectIndex = 1;
         }
         this._sex = this._model.sex;
      }
      
      private function __updateRegisterGlow(param1:CivilEvent) : void
      {
      }
      
      private function setButtonState(param1:Boolean, param2:Boolean) : void
      {
         this._preBtn.mouseChildren = param1;
         this._preBtn.enable = param1;
         this._nextBtn.mouseChildren = param2;
         this._nextBtn.enable = param2;
      }
      
      private function __updateView(param1:CivilEvent) : void
      {
         this._isBusy = false;
         this.updateButton();
         this._loadMember = false;
      }
   }
}
