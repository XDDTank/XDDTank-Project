package ddt.data.analyze
{
   import com.pickgliss.loader.DataAnalyzer;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.data.DaylyGiveInfo;
   import flash.utils.Dictionary;
   import platformapi.tencent.DiamondManager;
   import road7th.data.DictionaryData;
   
   public class DaylyGiveAnalyzer extends DataAnalyzer
   {
       
      
      public var list:Array;
      
      public var signAwardList:Array;
      
      public var signAwardCounts:Array;
      
      public var userAwardLog:int;
      
      public var awardLen:int;
      
      private var _xml:XML;
      
      private var _awardDic:Dictionary;
      
      public var memberDimondAwardList:DictionaryData;
      
      public var yearMemberDimondAwardList:DictionaryData;
      
      public var memberDimondNewHandAwardList:DictionaryData;
      
      public var bluememberDimondAwardList:DictionaryData;
      
      public var blueyearMemberDimondAwardList:DictionaryData;
      
      public var bluememberDimondNewHandAwardList:DictionaryData;
      
      public var memberQPlusAwardList:DictionaryData;
      
      public var memberQPlusYearAwardList:DictionaryData;
      
      public var memberQPlusNewHandAwardList:DictionaryData;
      
      public var bunAwardList:DictionaryData;
      
      private var _receiveDic:Array;
      
      public function DaylyGiveAnalyzer(param1:Function)
      {
         super(param1);
      }
      
      override public function analyze(param1:*) : void
      {
         var _loc2_:XMLList = null;
         var _loc3_:int = 0;
         var _loc4_:DaylyGiveInfo = null;
         var _loc5_:DaylyGiveInfo = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Array = null;
         var _loc11_:Array = null;
         this._xml = new XML(param1);
         this.list = new Array();
         this.signAwardList = new Array();
         this._awardDic = new Dictionary(true);
         this.signAwardCounts = new Array();
         this.memberDimondAwardList = new DictionaryData();
         this.yearMemberDimondAwardList = new DictionaryData();
         this.memberDimondNewHandAwardList = new DictionaryData();
         this.bluememberDimondAwardList = new DictionaryData();
         this.blueyearMemberDimondAwardList = new DictionaryData();
         this.bluememberDimondNewHandAwardList = new DictionaryData();
         this.memberQPlusAwardList = new DictionaryData();
         this.memberQPlusYearAwardList = new DictionaryData();
         this.memberQPlusNewHandAwardList = new DictionaryData();
         this.bunAwardList = new DictionaryData();
         this._receiveDic = new Array();
         if(this._xml.@value == "true")
         {
            _loc2_ = this._xml..Item;
            _loc3_ = 0;
            while(_loc3_ < _loc2_.length())
            {
               _loc5_ = new DaylyGiveInfo();
               ObjectUtils.copyPorpertiesByXML(_loc5_,_loc2_[_loc3_]);
               this._receiveDic.push(_loc5_);
               if(_loc2_[_loc3_].@GetWay == DailyAwardType.Normal)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.list.push(_loc4_);
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.Sign)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.signAwardList.push(_loc4_);
                  if(!this._awardDic[String(_loc2_[_loc3_].@NeedLevel)])
                  {
                     this._awardDic[String(_loc2_[_loc3_].@NeedLevel)] = true;
                     this.signAwardCounts.push(_loc2_[_loc3_].@NeedLevel);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.MemberDimondAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  if(this.memberDimondAwardList[_loc4_.NeedLevel])
                  {
                     (this.memberDimondAwardList[_loc4_.NeedLevel] as Array).push(_loc4_);
                  }
                  else
                  {
                     _loc6_ = new Array();
                     _loc6_.push(_loc4_);
                     this.memberDimondAwardList.add(_loc4_.NeedLevel,_loc6_);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.YearMemberDimondAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  if(this.yearMemberDimondAwardList[_loc4_.NeedLevel])
                  {
                     (this.yearMemberDimondAwardList[_loc4_.NeedLevel] as Array).push(_loc4_);
                  }
                  else
                  {
                     _loc7_ = new Array();
                     _loc7_.push(_loc4_);
                     this.yearMemberDimondAwardList.add(_loc4_.NeedLevel,_loc7_);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.MemberDimondNewHandAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.memberDimondNewHandAwardList.add(_loc4_.ID,_loc4_);
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.BlueMemberDimondAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  if(this.bluememberDimondAwardList[_loc4_.NeedLevel])
                  {
                     (this.bluememberDimondAwardList[_loc4_.NeedLevel] as Array).push(_loc4_);
                  }
                  else
                  {
                     _loc8_ = new Array();
                     _loc8_.push(_loc4_);
                     this.bluememberDimondAwardList.add(_loc4_.NeedLevel,_loc8_);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.BlueYearMemberDimondAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  if(this.blueyearMemberDimondAwardList[_loc4_.NeedLevel])
                  {
                     (this.blueyearMemberDimondAwardList[_loc4_.NeedLevel] as Array).push(_loc4_);
                  }
                  else
                  {
                     _loc9_ = new Array();
                     _loc9_.push(_loc4_);
                     this.blueyearMemberDimondAwardList.add(_loc4_.NeedLevel,_loc9_);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.BlueMemberDimondNewHandAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.bluememberDimondNewHandAwardList.add(_loc4_.ID,_loc4_);
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.memberQPlusAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  if(this.memberQPlusAwardList[_loc4_.NeedLevel])
                  {
                     (this.memberQPlusAwardList[_loc4_.NeedLevel] as Array).push(_loc4_);
                  }
                  else
                  {
                     _loc10_ = new Array();
                     _loc10_.push(_loc4_);
                     this.memberQPlusAwardList.add(_loc4_.NeedLevel,_loc10_);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.memberQPlusYearAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  if(this.memberQPlusYearAwardList[_loc4_.NeedLevel])
                  {
                     (this.memberQPlusYearAwardList[_loc4_.NeedLevel] as Array).push(_loc4_);
                  }
                  else
                  {
                     _loc11_ = new Array();
                     _loc11_.push(_loc4_);
                     this.memberQPlusYearAwardList.add(_loc4_.NeedLevel,_loc11_);
                  }
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.memberQPlusNewHandAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.memberQPlusNewHandAwardList.add(_loc4_.ID,_loc4_);
               }
               else if(_loc2_[_loc3_].@GetWay == DailyAwardType.BunAward)
               {
                  _loc4_ = new DaylyGiveInfo();
                  ObjectUtils.copyPorpertiesByXML(_loc4_,_loc2_[_loc3_]);
                  this.bunAwardList.add(_loc4_.NeedLevel,_loc4_);
               }
               _loc3_++;
            }
            DiamondManager.instance.model.setList(this.memberDimondAwardList,this.yearMemberDimondAwardList,this.memberDimondNewHandAwardList,this.bluememberDimondAwardList,this.blueyearMemberDimondAwardList,this.bluememberDimondNewHandAwardList,this.memberQPlusAwardList,this.memberQPlusYearAwardList,this.memberQPlusNewHandAwardList,this.bunAwardList);
            onAnalyzeComplete();
         }
         else
         {
            message = this._xml.@message;
            onAnalyzeError();
            onAnalyzeComplete();
         }
      }
      
      public function get awardList() : Array
      {
         return this._receiveDic;
      }
   }
}
