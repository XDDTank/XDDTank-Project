using System;
using System.Collections.Generic;
using System.Text;

namespace SqlDataProvider.Data
{
    public class PetSkillTemplateInfo
    {
        public int ID { set; get; }

        public int PetTemplateID { set; get; }

        public int KindID { set; get; }

        public int GetType { set; get; }

        public int SkillID { set; get; }

        public int SkillBookID { set; get; }

        public int MinLevel { set; get; }

        public string DeleteSkillIDs { set; get; }
    }
}
