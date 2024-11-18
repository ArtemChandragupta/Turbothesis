from   scipy.interpolate     import make_interp_spline
from   matplotlib.patches    import Arc
from   matplotlib.transforms import Bbox, IdentityTransform, TransformedBbox
import matplotlib.pyplot     as plt
import numpy                 as np
import math
import matplotlib.patches    as mpatches

cz1 = 1.4
cz2 = 1.39333
u   = 1.3557
p1  = cz1*math.tan(1/88.748)
p2  =-cz2*math.tan(1/88.748)
pw1 = p1 - u
pw2 = p2 + u

fig, ax = plt.subplots()

# Ось U
arr = mpatches.FancyArrowPatch((-u,0),(u,0),arrowstyle='->,head_width=.15', mutation_scale=20)
ax.add_patch(arr)
ax.annotate(r'$C_1$=192.92 м/с', (1.5, .1), xycoords=arr, ha='center', va='bottom',rotation=-88.748)
ax.text(u, -0.1, 'U')
# Вспомогательные кострукции
ax.arrow(0 ,  0        ,  p1    , -cz1, color='r',alpha=0)
ax.arrow(p1, -cz1+0.005, -u+0.01,  0  , color='r')
ax.arrow(p2, -cz2+0.006,  u-0.01,  0  , color='b')

# Вертикальные палочки
ax.arrow(pw1, -cz1-0.1, 0, 0.1,width=0)
ax.arrow(pw2, -cz2-0.2, 0, 0.2,width=0)
ax.arrow(p1 , -cz1-0.1, 0, 0.1,width=0)
ax.arrow(p2 , -cz2-0.2, 0, 0.2,width=0)

# Мелкие стрелки внутри
arr = mpatches.FancyArrowPatch((0, 0),(p1, -cz1),arrowstyle='->,head_width=.15', mutation_scale=20,color='r')
ax.add_patch(arr)
ax.annotate(r'$C_1$=140.244 м/с', (1.5, .1), xycoords=arr, ha='center', va='bottom',rotation=-88.748)
arr = mpatches.FancyArrowPatch((0, 0),(p2, -cz2),arrowstyle='->,head_width=.15', mutation_scale=20,color='b')
ax.add_patch(arr)
ax.annotate(r'$W_2=139.367 м/с$', (-1.5, .1), xycoords=arr, ha='center', va='bottom',rotation=88.748)

# Большие стрелки снаружи
arr = mpatches.FancyArrowPatch((0, 0),(pw1, -cz1),arrowstyle='->,head_width=.15',mutation_scale=20,color='r')
ax.add_patch(arr)
ax.annotate(r'$W_1=192.767 м/с$',(.5, .5),xycoords=arr,ha='center',va='bottom',rotation=46.574)
arr = mpatches.FancyArrowPatch((0, 0),(pw2, -cz2),arrowstyle='->,head_width=.15', mutation_scale=20,color='b')
ax.add_patch(arr)
ax.annotate(r'$C_2=192.284 м/с$', (.5, .5), xycoords=arr, ha='center', va='bottom',rotation=-45.163)

# Двойные черные стрелки снизу
arr = mpatches.FancyArrowPatch((p1+0.01, -cz1-0.1),(pw1-0.01, -cz1-0.1),arrowstyle='<->,head_width=.15',mutation_scale=20)
ax.add_patch(arr)
ax.annotate(r'$U=135.57 м/с$',(.5, .5),xycoords=arr,ha='center',va='top')
arr = mpatches.FancyArrowPatch((p2-0.01, -cz2-0.2),(pw2+0.01, -cz2-0.2),arrowstyle='<->,head_width=.15', mutation_scale=20)
ax.add_patch(arr)
ax.annotate(r'$U=135.57 м/с$',(.5, .5),xycoords=arr,ha='center',va='top')

# Вертикальные скорости
arr = mpatches.FancyArrowPatch((pw1/4*3, 0),(pw1/4*3, -cz1),arrowstyle='->,head_width=.15', mutation_scale=20,color='y',alpha=0.5)
ax.add_patch(arr)
ax.annotate(r'$C_{z_1}=140 м/с$', (1.5, .1), xycoords=arr, ha='center', va='bottom',rotation=-88.748)
arr = mpatches.FancyArrowPatch((pw2/4*3, 0),(pw2/4*3, -cz2),arrowstyle='->,head_width=.15', mutation_scale=20,color='y',alpha=0.5)
ax.add_patch(arr)
ax.annotate(r'$C_{z_2}=139.333 м/с$', (-1.5, .1), xycoords=arr, ha='center', va='bottom',rotation=88.748)

# Углы
class AngleAnnotation(Arc):
    def __init__(self, xy, p1, p2, size=75, unit="points", ax=None,
                 text="", textposition="inside", text_kw=None, **kwargs): 
        self.ax = ax or plt.gca()
        self._xydata = xy  # in data coordinates
        self.vec1 = p1
        self.vec2 = p2
        self.size = size
        self.unit = unit
        self.textposition = textposition

        super().__init__(self._xydata, size, size, angle=0.0,
                         theta1=self.theta1, theta2=self.theta2, **kwargs)

        self.set_transform(IdentityTransform())
        self.ax.add_patch(self)

        self.kw = dict(ha="center", va="center",
                       xycoords=IdentityTransform(),
                       xytext=(0, 0), textcoords="offset points",
                       annotation_clip=True)
        self.kw.update(text_kw or {})
        self.text = ax.annotate(text, xy=self._center, **self.kw)

    def get_size(self):
        factor = 1.
        if self.unit == "points":
            factor = self.ax.figure.dpi / 72.
        elif self.unit[:4] == "axes":
            b = TransformedBbox(Bbox.unit(), self.ax.transAxes)
            dic = {"max": max(b.width, b.height),
                   "min": min(b.width, b.height),
                   "width": b.width, "height": b.height}
            factor = dic[self.unit[5:]]
        return self.size * factor

    def set_size(self, size):
        self.size = size

    def get_center_in_pixels(self):
        """return center in pixels"""
        return self.ax.transData.transform(self._xydata)

    def set_center(self, xy):
        """set center in data coordinates"""
        self._xydata = xy

    def get_theta(self, vec):
        vec_in_pixels = self.ax.transData.transform(vec) - self._center
        return np.rad2deg(np.arctan2(vec_in_pixels[1], vec_in_pixels[0]))

    def get_theta1(self):
        return self.get_theta(self.vec1)

    def get_theta2(self):
        return self.get_theta(self.vec2)

    def set_theta(self, angle):
        pass

    # Redefine attributes of the Arc to always give values in pixel space
    _center = property(get_center_in_pixels, set_center)
    theta1  = property(get_theta1          , set_theta )
    theta2  = property(get_theta2          , set_theta )
    width   = property(get_size            , set_size  )
    height  = property(get_size            , set_size  )

    # The following two methods are needed to update the text position.
    def draw(self, renderer):
        self.update_text()
        super().draw(renderer)

    def update_text(self):
        c = self._center
        s = self.get_size()
        angle_span = (self.theta2 - self.theta1) % 360
        angle = np.deg2rad(self.theta1 + angle_span / 2)
        r = s / 2
        if self.textposition == "inside":
            r = s / np.interp(angle_span, [60, 90, 135, 180],
                                          [3.3, 3.5, 3.8, 4])
        self.text.xy = c + r * np.array([np.cos(angle), np.sin(angle)])
        if self.textposition == "outside":
            def R90(a, r, w, h):
                if a < np.arctan(h/2/(r+w/2)):
                    return np.sqrt((r+w/2)**2 + (np.tan(a)*(r+w/2))**2)
                else:
                    c = np.sqrt((w/2)**2+(h/2)**2)
                    T = np.arcsin(c * np.cos(np.pi/2 - a + np.arcsin(h/2/c))/r)
                    xy = r * np.array([np.cos(a + T), np.sin(a + T)])
                    xy += np.array([w/2, h/2])
                    return np.sqrt(np.sum(xy**2))

            def R(a, r, w, h):
                aa = (a % (np.pi/4))*((a % (np.pi/2)) <= np.pi/4) + \
                     (np.pi/4 - (a % (np.pi/4)))*((a % (np.pi/2)) >= np.pi/4)
                return R90(aa, r, *[w, h][::int(np.sign(np.cos(2*a)))])

            bbox = self.text.get_window_extent()
            X = R(angle, r, bbox.width, bbox.height)
            trans = self.ax.figure.dpi_scale_trans.inverted()
            offs = trans.transform(((X-s/2), 0))[0] * 72
            self.text.set_position([offs*np.cos(angle), offs*np.sin(angle)])

am1 = AngleAnnotation((0,0),(-2    ,  0  ),(pw1    , -cz1),ax=ax,size=75, text=r"$46.57°$",textposition="edge")
am2 = AngleAnnotation((0,0),(pw2   , -cz2),(2      ,  0  ),ax=ax,size=75, text=r"$42.16°$",textposition="edge")
am3 = AngleAnnotation((0,0),(0.0157, -cz1),(2      ,  0  ),ax=ax,size=175,text=r"$88.54°$",textposition="edge")
am4 = AngleAnnotation((0,0),(-2    ,  0  ),(-0.0157, -cz1),ax=ax,size=175,text=r"$88.75°$",textposition="edge")

ax.axes.xaxis.set_ticks([])
ax.axes.yaxis.set_ticks([])

plt.show()
