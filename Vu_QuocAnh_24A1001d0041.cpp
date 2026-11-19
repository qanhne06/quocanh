#include <iostream>
#include <string>
#include <iomanip>
using namespace std;

struct DienThoai {
    string maDT;
    string tenDT;
    double giaBan;
    string nhaCungCap;
};

struct Nut {
    DienThoai data;
    Nut* truoc;
    Nut* sau;
};

Nut* taoNut(const DienThoai& dt) {
    Nut* p = new Nut;
    p->data = dt;
    p->truoc = p->sau = NULL;
    return p;
}

void nhap1DT(DienThoai &dt) {
    cout << "Nhap ma DT: "; getline(cin, dt.maDT);
    cout << "Nhap ten DT: "; getline(cin, dt.tenDT);
    cout << "Nhap gia ban: "; cin >> dt.giaBan;
    cin.ignore();
    cout << "Nhap nha cung cap: "; getline(cin, dt.nhaCungCap);
}

void xuat1DT(const DienThoai &dt) {
    cout << left << setw(12) << dt.maDT
         << setw(25) << dt.tenDT
         << setw(12) << dt.giaBan
         << setw(20) << dt.nhaCungCap << endl;
}

void nhapDanhSach(Nut*& dau, Nut*& cuoi) {
    int n;
    cout << "Nhap so luong dien thoai: ";
    cin >> n;
    cin.ignore();
    for (int i = 0; i < n; i++) {
        cout << "\n-- Nhap dien thoai thu " << i + 1 << " --\n";
        DienThoai dt;
        nhap1DT(dt);
        Nut* p = taoNut(dt);
        if (!dau) dau = cuoi = p;
        else {
            cuoi->sau = p;
            p->truoc = cuoi;
            cuoi = p;
        }
    }
}

void inDanhSach(Nut* dau) {
    if (!dau) {
        cout << "Danh sach rong.\n";
        return;
    }
    cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
    cout << string(69, '-') << endl;
    for (Nut* p = dau; p; p = p->sau) xuat1DT(p->data);
}

void chenDau(Nut*& dau, Nut*& cuoi, const DienThoai &dt) {
    Nut* p = taoNut(dt);
    if (!dau) dau = cuoi = p;
    else {
        p->sau = dau;
        dau->truoc = p;
        dau = p;
    }
}

void chenCuoi(Nut*& dau, Nut*& cuoi, const DienThoai &dt) {
    Nut* p = taoNut(dt);
    if (!dau) dau = cuoi = p;
    else {
        cuoi->sau = p;
        p->truoc = cuoi;
        cuoi = p;
    }
}

void huyDau(Nut*& dau, Nut*& cuoi) {
    if (!dau) return;
    Nut* p = dau;
    dau = dau->sau;
    if (dau) dau->truoc = NULL;
    else cuoi = NULL;
    delete p;
}

void huyCuoi(Nut*& dau, Nut*& cuoi) {
    if (!cuoi) return;
    Nut* p = cuoi;
    cuoi = cuoi->truoc;
    if (cuoi) cuoi->sau = NULL;
    else dau = NULL;
    delete p;
}

Nut* timTuyenTinh(Nut* dau, const string &ma) {
    for (Nut* p = dau; p; p = p->sau)
        if (p->data.maDT == ma) return p;
    return NULL;
}

void chenTruocMaX(Nut*& dau, Nut*& cuoi, const string &maX) {
    Nut* q = timTuyenTinh(dau, maX);
    if (!q) {
        cout << "Khong tim thay ma " << maX << endl;
        return;
    }
    DienThoai dt;
    cout << "Nhap thong tin dien thoai can chen truoc ma " << maX << ":\n";
    nhap1DT(dt);
    Nut* p = taoNut(dt);
    p->sau = q;
    p->truoc = q->truoc;
    if (q->truoc) q->truoc->sau = p;
    else dau = p;
    q->truoc = p;
}

void xoaTheoMa(Nut*& dau, Nut*& cuoi, const string &maX) {
    Nut* q = timTuyenTinh(dau, maX);
    if (!q) {
        cout << "Khong tim thay ma " << maX << endl;
        return;
    }
    if (q == dau) {
        huyDau(dau, cuoi);
        cout << "Da xoa ma " << maX << endl;
        return;
    }
    if (q == cuoi) {
        huyCuoi(dau, cuoi);
        cout << "Da xoa ma " << maX << endl;
        return;
    }
    q->truoc->sau = q->sau;
    q->sau->truoc = q->truoc;
    delete q;
    cout << "Da xoa ma " << maX << endl;
}

void inTheoKhoangGia(Nut* dau, double x, double y) {
    bool found = false;
    cout << "\nCac dien thoai co gia trong khoang [" << x << ", " << y << "]:\n";
    cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
    for (Nut* p = dau; p; p = p->sau)
        if (p->data.giaBan >= x && p->data.giaBan <= y) {
            xuat1DT(p->data);
            found = true;
        }
    if (!found) cout << "Khong co dien thoai nao.\n";
}

void toArray(Nut* dau, DienThoai a[], int &n) {
    n = 0;
    for (Nut* p = dau; p; p = p->sau) {
        a[n++] = p->data;
    }
}

void selectionSort_Ten(DienThoai a[], int n) {
    for (int i = 0; i < n - 1; i++) {
        int minIdx = i;
        for (int j = i + 1; j < n; j++)
            if (a[j].tenDT < a[minIdx].tenDT) minIdx = j;
        if (minIdx != i) swap(a[i], a[minIdx]);
    }
}

void insertionSort_Ma(DienThoai a[], int n) {
    for (int i = 1; i < n; i++) {
        DienThoai key = a[i];
        int j = i - 1;
        while (j >= 0 && a[j].maDT < key.maDT) {
            a[j + 1] = a[j];
            j--;
        }
        a[j + 1] = key;
    }
}

void sapXepTangTheoTenVaIn(Nut* dau) {
    DienThoai a[1000];
    int n;
    toArray(dau, a, n);
    if (n == 0) { cout << "Danh sach rong.\n"; return; }
    selectionSort_Ten(a, n);
    cout << "\nDanh sach sau khi sap xep tang theo Ten:\n";
    cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
    for (int i = 0; i < n; i++) xuat1DT(a[i]);
}

void sapXepGiamTheoMaVaIn(Nut* dau) {
    DienThoai a[1000];
    int n;
    toArray(dau, a, n);
    if (n == 0) { cout << "Danh sach rong.\n"; return; }
    insertionSort_Ma(a, n);
    cout << "\nDanh sach sau khi sap xep giam theo Ma:\n";
    cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
    for (int i = 0; i < n; i++) xuat1DT(a[i]);
}

void binarySearch_NCC(Nut* dau, const string &x) {
    DienThoai a[1000];
    int n;
    toArray(dau, a, n);
    if (n == 0) { cout << "Danh sach rong.\n"; return; }
    for (int i = 0; i < n - 1; i++)
        for (int j = i + 1; j < n; j++)
            if (a[i].nhaCungCap > a[j].nhaCungCap) swap(a[i], a[j]);
    int left = 0, right = n - 1;
    bool found = false;
    while (left <= right) {
        int mid = (left + right) / 2;
        if (a[mid].nhaCungCap == x) {
            int l = mid, r = mid;
            while (l >= 0 && a[l].nhaCungCap == x) l--;
            while (r < n && a[r].nhaCungCap == x) r++;
            cout << "\nCac dien thoai co NCC = " << x << ":\n";
            cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
            for (int i = l + 1; i < r; i++) xuat1DT(a[i]);
            found = true;
            break;
        } else if (a[mid].nhaCungCap < x) left = mid + 1;
        else right = mid - 1;
    }
    if (!found) cout << "Khong co dien thoai nao thuoc NCC nay.\n";
}

void inGiaCaoNhat(Nut* dau) {
    if (!dau) { cout << "Danh sach rong.\n"; return; }
    double maxGia = dau->data.giaBan;
    for (Nut* p = dau; p; p = p->sau)
        if (p->data.giaBan > maxGia) maxGia = p->data.giaBan;
    cout << "\nCac dien thoai co gia cao nhat (" << maxGia << "):\n";
    cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
    for (Nut* p = dau; p; p = p->sau)
        if (p->data.giaBan == maxGia) xuat1DT(p->data);
}

int main() {
    Nut* dau = NULL;
    Nut* cuoi = NULL;
    int chon;
    do {
        cout << "\n===== MENU =====\n";
        cout << "1. Nhap 1 dien thoai\n";
        cout << "2. Nhap danh sach dien thoai tu ban phim\n";
        cout << "3. In danh sach da nhap\n";
        cout << "4. Chen dien thoai vao dau\n";
        cout << "5. Chen dien thoai vao cuoi\n";
        cout << "6. Huy dien thoai o dau\n";
        cout << "7. Huy dien thoai o cuoi\n";
        cout << "8. Tim dien thoai theo ma (tuyen tinh)\n";
        cout << "9. Chen truoc dien thoai co ma = x\n";
        cout << "10. Xoa dien thoai co ma = x\n";
        cout << "11. In cac dien thoai co gia trong [x, y]\n";
        cout << "12. Sap xep tang theo Ten (SelectionSort)\n";
        cout << "13. Sap xep giam theo Ma (InsertionSort)\n";
        cout << "14. Tim cac dien thoai co NCC = x (Binary Search)\n";
        cout << "15. In cac dien thoai co gia ban cao nhat\n";
        cout << "0. Thoat\n";
        cout << "Chon: ";
        cin >> chon;
        cin.ignore();
        switch (chon) {
            case 1: {
                DienThoai dt;
                nhap1DT(dt);
                cout << "\nThong tin dien thoai vua nhap:\n";
                cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
                xuat1DT(dt);
                break;
            }
            case 2:
                nhapDanhSach(dau, cuoi);
                break;
            case 3:
                inDanhSach(dau);
                break;
            case 4: {
                DienThoai dt;
                nhap1DT(dt);
                chenDau(dau, cuoi, dt);
                break;
            }
            case 5: {
                DienThoai dt;
                nhap1DT(dt);
                chenCuoi(dau, cuoi, dt);
                break;
            }
            case 6:
                huyDau(dau, cuoi);
                cout << "Da huy o dau (neu co).\n";
                break;
            case 7:
                huyCuoi(dau, cuoi);
                cout << "Da huy o cuoi (neu co).\n";
                break;
            case 8: {
                string ma;
                cout << "Nhap ma can tim: ";
                getline(cin, ma);
                Nut* p = timTuyenTinh(dau, ma);
                if (p) {
                    cout << "Tim thay:\n";
                    cout << left << setw(12) << "MaDT" << setw(25) << "TenDT" << setw(12) << "GiaBan" << setw(20) << "NhaCC" << endl;
                    xuat1DT(p->data);
                } else cout << "Khong tim thay!\n";
                break;
            }
            case 9: {
                string ma;
                cout << "Nhap ma x (chen truoc): ";
                getline(cin, ma);
                chenTruocMaX(dau, cuoi, ma);
                break;
            }
            case 10: {
                string ma;
                cout << "Nhap ma can xoa: ";
                getline(cin, ma);
                xoaTheoMa(dau, cuoi, ma);
                break;
            }
            case 11: {
                double x, y;
                cout << "Nhap x y: ";
                cin >> x >> y;
                cin.ignore();
                inTheoKhoangGia(dau, x, y);
                break;
            }
            case 12:
                sapXepTangTheoTenVaIn(dau);
                break;
            case 13:
                sapXepGiamTheoMaVaIn(dau);
                break;
            case 14: {
                string ncc;
                cout << "Nhap NCC can tim: ";
                getline(cin, ncc);
                binarySearch_NCC(dau, ncc);
                break;
            }
            case 15:
                inGiaCaoNhat(dau);
                break;
            case 0:
                cout << "Thoat.\n";
                break;
            default:
                cout << "Lua chon khong hop le.\n";
        }
    } while (chon != 0);

    while (dau) {
        Nut* t = dau;
        dau = dau->sau;
        delete t;
    }

    return 0;
}

