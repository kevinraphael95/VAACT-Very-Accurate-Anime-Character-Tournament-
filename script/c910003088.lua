--Ａｉの儀式
--A.I.'s Ritual
--Scripted by edo9300
local s,id=GetID()
function s.initial_effect(c)
	-- === AJOUT AUTO : considérée comme la carte officielle (ID 85327820) ===
	local e_add_code = Effect.CreateEffect(c)
	e_add_code:SetType(EFFECT_TYPE_SINGLE)
	e_add_code:SetCode(EFFECT_ADD_CODE)
	e_add_code:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_add_code:SetValue(85327820)
	c:RegisterEffect(e_add_code)
	-- =====================================================================
	--Activate
	local e1=Ritual.CreateProc(c,RITPROC_GREATER,aux.FilterBoolFunction(Card.IsRace,RACE_CYBERSE),nil,nil,s.extrafil,nil,aux.FilterBoolFunction(Card.IsSetCard,SET_IGNISTER))
	local tg=e1:GetTarget()
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk,...)
					if chk==0 then
						if Duel.IsExistingMatchingCard(aux.FaceupFilter(Card.IsSetCard,SET_IGNISTER),tp,LOCATION_MZONE,0,1,nil) then
							e:SetLabel(1)
						else
							e:SetLabel(0)
						end
					end
					if chk==1 and e:GetLabel()==1 then
						Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
					end
					return tg(e,tp,eg,ep,ev,re,r,rp,chk,...)
				end)
	local op=e1:GetOperation()
	e1:SetOperation(function(e,...)
						local ret=op(e,...)
						if e:GetLabel()==1 then
							e:SetLabel(0)
						end
						return ret
					end)
	c:RegisterEffect(e1)
end
s.listed_series={SET_IGNISTER}
function s.mfilter(c)
	return not Duel.IsPlayerAffectedByEffect(c:GetControler(),CARD_SPIRIT_ELIMINATION)
		and c:IsSetCard(SET_IGNISTER) and c:IsLevelAbove(1) and c:IsAbleToRemove()
end
function s.extrafil(e,tp,eg,ep,ev,re,r,rp,chk)
	if e:GetLabel()==1 then
		return Duel.GetMatchingGroup(s.mfilter,tp,LOCATION_GRAVE,0,nil)
	end
end